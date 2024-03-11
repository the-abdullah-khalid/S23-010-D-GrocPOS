//const functions = require("firebase-functions");
//const admin = require("firebase-admin");
//
//admin.initializeApp();
//exports.sendNotificationLowStock = functions.firestore
//  .document("/retail_shop_users/{userId}/products/{productId}")
//  .onUpdate(async (snap, context) => {
//    const oldData = snap.before.data();
//    const newData = snap.after.data();
//
//    const userId = context.params.userId;
//    const productId = context.params.productId;
//
//    const newStock = newData.product_stock;
//    const previousStock = oldData.product_stock;
//
//    if (newStock !== 25) {
//      const payload = {
//        notification: {
//          title: "Product Stock Is Low",
//          body: `Add more stock to increase sales. Product Details: ${productId}`,
//          sound: "beep",
//          channel_id: "0",
//          android_channel_id: "0",
//          priority: "high",
//        },
//      };
//      try {
//        const retailShopDoc = await admin
//          .firestore()
//          .collection("retail_shop_users")
//          .doc(userId)
//          .get();
//        const deviceToken = retailShopDoc.data().shop_device_fcm_token;
//        const response = await admin
//          .messaging()
//          .sendToDevice(deviceToken, payload);
//        console.log("Notification sent successfully:", response);
//      } catch (error) {
//        console.error("Error sending notification:", error);
//      }
//    }
//  });
//
//exports.checkExpiration = functions.pubsub
//  .schedule("every 24 hours")
//  .timeZone("your-timezone")
//  .onRun(async (context) => {
//    const today = new Date();
//    const expiredProducts = [];
//
//    // Query all retail shop users
//    const usersSnapshot = await firestore.collectionGroup("products").get();
//
//    // Iterate through each user
//    usersSnapshot.forEach((userDoc) => {
//      // Iterate through each product
//      userDoc.ref
//        .collection("products")
//        .get()
//        .then((productsSnapshot) => {
//          productsSnapshot.forEach((productDoc) => {
//            const productData = productDoc.data();
//
//            // Check if the product has an expiration date
//            if (productData.expirationDate) {
//              const expirationDate = new Date(productData.expirationDate);
//
//              // Compare expiration date with today's date
//              if (expirationDate < today) {
//                expiredProducts.push({
//                  userId: userDoc.id,
//                  productId: productDoc.id,
//                  productName: productData.name, // Replace with the actual field name
//                  expirationDate: expirationDate.toISOString(),
//                });
//
//                // Delete the expired product
//                productDoc.ref.delete();
//              }
//            }
//          });
//        });
//    });
//
//    // Log or handle the list of expired products
//    console.log("Expired Products:", expiredProducts);
//
//    return null;
//  });
//
//exports.checkExpirationPustNotification = functions.pubsub
//  .schedule("every 24 hours")
//  .timeZone("Asia/Karachi")
//  .onRun(async (context) => {
//    const today = new Date();
//    const expiredProducts = [];
//
//    try {
//      // Query all retail shop users
//      const usersSnapshot = await firestore.collectionGroup("products").get();
//
//      // Iterate through each user
//      usersSnapshot.forEach((userDoc) => {
//        // Iterate through each product
//        userDoc.ref
//          .collection("products")
//          .get()
//          .then((productsSnapshot) => {
//            productsSnapshot.forEach((productDoc) => {
//              const productData = productDoc.data();
//
//              // Check if the product has an expiration date
//              if (productData.expirationDate) {
//                const expirationDate = new Date(productData.expirationDate);
//
//                // Compare expiration date with today's date
//                if (expirationDate < today) {
//                  expiredProducts.push({
//                    userId: userDoc.id,
//                    productId: productDoc.id,
//                    productName: productData.name, // Replace with the actual field name
//                    expirationDate: expirationDate.toISOString(),
//                  });
//
//                  // Delete the expired product
//                  productDoc.ref.delete();
//                }
//                const deviceToken = retailShopDoc.data().shop_device_fcm_token;
//              }
//            });
//          });
//      });
//
//      // Log or handle the list of expired products
//      console.log("Expired Products:", expiredProducts);
//      return null;
//    } catch (error) {
//      console.error("Error:", error);
//      return null;
//    }
//  });
//
//exports.notifyExpiringProductsInWeek = functions.pubsub
//  .schedule("every 24 hours")
//  .timeZone("Asia/Karachi")
//  .onRun(async (context) => {
//    const oneWeekFromNow = new Date();
//    oneWeekFromNow.setDate(oneWeekFromNow.getDate() + 7);
//
//    try {
//      // Query all retail shop users
//      const usersSnapshot = await firestore.collectionGroup("products").get();
//
//      // Iterate through each user
//      usersSnapshot.forEach((userDoc) => {
//        // Iterate through each product
//        userDoc.ref
//          .collection("products")
//          .get()
//          .then((productsSnapshot) => {
//            productsSnapshot.forEach((productDoc) => {
//              const productData = productDoc.data();
//
//              // Check if the product has an expiration date
//              if (productData.expirationDate) {
//                const expirationDate = new Date(productData.expirationDate);
//
//                // Compare expiration date with one week from now
//                if (
//                  expirationDate > oneWeekFromNow &&
//                  expirationDate <= oneWeekFromNow
//                ) {
//                  const userId = userDoc.id;
//                  const productName = productData.name; // Replace with the actual field name
//
//                  // Send notification to the user
//                  sendNotification(userId, productName);
//
//                  const deviceToken =
//                    retailShopDoc.data().shop_device_fcm_token;
//                }
//              }
//            });
//          });
//      });
//
//      return null;
//    } catch (error) {
//      console.error("Error:", error);
//      return null;
//    }
//  });
//
//// Function to send FCM notification
//function sendNotification(userId, productName) {
//  const message = {
//    data: {
//      title: "Product Expiry Reminder",
//      body: `Your product "${productName}" will expire within one week. Please check the expiry date.`,
//    },
//    token: getDeviceToken(userId), // Replace with a function to get the user's device token
//  };
//
//  admin
//    .messaging()
//    .send(message)
//    .then((response) => {
//      console.log("Notification sent successfully:", response);
//    })
//    .catch((error) => {
//      console.error("Error sending notification:", error);
//    });
//}
//
//async function getDeviceToken(userId) {
//  const deviceToken = retailShopDoc.data().shop_device_fcm_token;
//  const response = await admin.messaging().sendToDevice(deviceToken, payload);
//  console.log("Notification sent successfully:", response);
//  return null;
//}

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Cloud Firestore triggers ref: https://firebase.google.com/docs/functions/firestore-events
exports.myFunction = functions.firestore
  .document("retail-shop-users/{shop_id}/products/{product_id}")
  .onUpdate((snapshot, context) => {
    // Return this function's promise, so this ensures the firebase function
    // will keep running, until the notification is scheduled.
    return admin.messaging().sendToTopic("chat", {
      // Sending a notification message.
      notification: {
        title: snapshot.data()["username"],
        body: snapshot.data()["text"],
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    });
  });
