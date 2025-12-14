const admin = require("firebase-admin");
const cron = require("node-cron");

admin.initializeApp();

// Cron job: every day at 10:00 AM Europe/Skopje time
cron.schedule("0 10 * * *", async () => {
  console.log("Sending daily recipe notification...");

  const message = {
    topic: "recipe-of-the-day",
    notification: {
      title: "Recipe of the Day",
      body: "Open the app to see today’s recipe!",
    },
    android: {
      priority: "high",
      notification: {
        sound: "default",
        channelId: "recipe_channel",
      },
    },
  };

  try {
    const response = await admin.messaging().send(message);
    console.log("Notification sent successfully:", response);
  } catch (error) {
    console.error("Error sending notification:", error);
  }
}, {
  scheduled: true,
  timezone: "Europe/Skopje",
});
