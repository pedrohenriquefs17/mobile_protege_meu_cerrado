const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Inicializar o Firebase Admin SDK
admin.initializeApp();

exports.sendNearbyNotification = functions.firestore
  .document("ocorrencias/{ocorrenciaId}") // Substitua pelo nome da sua coleção
  .onCreate(async (snap, context) => {
    const ocorrencia = snap.data();

    // Obtenha os detalhes da ocorrência
    const { lat, lon, descricao } = ocorrencia;

    // Obtenha usuários no Firestore para verificar localizações próximas
    const usersSnapshot = await admin.firestore().collection("users").get();

    usersSnapshot.forEach(async (userDoc) => {
      const user = userDoc.data();

      // Calcular distância (simplificado ou use uma biblioteca de geolocalização)
      const distance = getDistance(lat, lon, user.lat, user.lon); // Defina `getDistance`

      if (distance <= 5) {
        // Por exemplo, 5 km
        const payload = {
          notification: {
            title: "Ocorrência Próxima!",
            body: `Nova ocorrência perto de você: ${descricao}`,
          },
        };

        // Enviar notificação para o token do usuário
        if (user.fcmToken) {
          await admin.messaging().sendToDevice(user.fcmToken, payload);
        }
      }
    });
  });

// Função para calcular a distância entre dois pontos geográficos
function getDistance(lat1, lon1, lat2, lon2) {
  const toRad = (value) => (value * Math.PI) / 180;
  const R = 6371; // Raio da Terra em km

  const dLat = toRad(lat2 - lat1);
  const dLon = toRad(lon2 - lon1);

  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRad(lat1)) *
      Math.cos(toRad(lat2)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c; // Distância em km
}
