/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

function calcularDistancia(lat1, lon1, lat2, lon2) {
  const R = 6371; // Raio da Terra em km
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
              Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
              Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c; // Distância em km
}

function enviarNotificacao(token, titulo, mensagem) {
  const payload = {
    notification: {
      title: titulo,
      body: mensagem,
    },
    data: {
      tipo: "nova_ocorrencia",
    },
  };

  return admin.messaging().sendToDevice(token, payload);
}

exports.notificarUsuariosProximos = functions.firestore
  .document("ocorrencias/{ocorrenciaId}")
  .onCreate(async (snap, context) => {
    const ocorrencia = snap.data();

    // Obter usuários cadastrados
    const usuariosSnapshot = await admin.firestore().collection("usuarios").get();

    const notificacoes = [];

    usuariosSnapshot.forEach((doc) => {
      const usuario = doc.data();
      const distancia = calcularDistancia(
        ocorrencia.lat, ocorrencia.lon,
        usuario.lat, usuario.lon,
      );

      if (distancia <= 5) { // Enviar notificação para usuários até 5km
        notificacoes.push(
          enviarNotificacao(
            usuario.fcmToken,
            "Nova ocorrência próxima!",
            `Um incidente foi relatado a ${distancia.toFixed(1)} km de sua localização.`,
          ),
        );
      }
    });

    await Promise.all(notificacoes);
    console.log("Notificações enviadas com sucesso.");
  });
