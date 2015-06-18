Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:35443 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbbFRNJC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 09:09:02 -0400
Received: by pdbci14 with SMTP id ci14so7971913pdb.2
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2015 06:09:02 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/2] staging: wilc1000: align #define macro
Date: Thu, 18 Jun 2015 22:08:50 +0900
Message-Id: <1434632931-16909-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150618_150914_957990_10689452)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Align #define macro.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 93 +++++++++++++++----------------
 1 file changed, 46 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3228824..2cb2607 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -17,53 +17,52 @@ extern u8 g_wilc_initialized;
 /*****************************************************************************/
 
 /* Message types of the Host IF Message Queue*/
-#define HOST_IF_MSG_SCAN					((u16)0)
-#define HOST_IF_MSG_CONNECT					((u16)1)
-#define HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO	((u16)2)
-#define HOST_IF_MSG_KEY						((u16)3)
-#define HOST_IF_MSG_RCVD_NTWRK_INFO			((u16)4)
-#define HOST_IF_MSG_RCVD_SCAN_COMPLETE		((u16)5)
-#define HOST_IF_MSG_CFG_PARAMS				((u16)6)
-#define HOST_IF_MSG_SET_CHANNEL				((u16)7)
-#define HOST_IF_MSG_DISCONNECT				((u16)8)
-#define HOST_IF_MSG_GET_RSSI				((u16)9)
-#define HOST_IF_MSG_GET_CHNL				((u16)10)
-#define HOST_IF_MSG_ADD_BEACON				((u16)11)
-#define HOST_IF_MSG_DEL_BEACON				((u16)12)
-#define HOST_IF_MSG_ADD_STATION				((u16)13)
-#define HOST_IF_MSG_DEL_STATION				((u16)14)
-#define HOST_IF_MSG_EDIT_STATION			((u16)15)
-#define HOST_IF_MSG_SCAN_TIMER_FIRED			((u16)16)
-#define HOST_IF_MSG_CONNECT_TIMER_FIRED		((u16)17)
-#define HOST_IF_MSG_POWER_MGMT				((u16)18)
-#define HOST_IF_MSG_GET_INACTIVETIME			((u16)19)
-#define HOST_IF_MSG_REMAIN_ON_CHAN			((u16)20)
-#define  HOST_IF_MSG_REGISTER_FRAME			((u16)21)
-#define HOST_IF_MSG_LISTEN_TIMER_FIRED     ((u16)22)
-#define HOST_IF_MSG_GET_LINKSPEED				((u16)23)
-#define HOST_IF_MSG_SET_WFIDRV_HANDLER		((u16)24)
-#define HOST_IF_MSG_SET_MAC_ADDRESS		((u16)25)
-#define HOST_IF_MSG_GET_MAC_ADDRESS		((u16)26)
-#define HOST_IF_MSG_SET_OPERATION_MODE		((u16)27)
-#define HOST_IF_MSG_SET_IPADDRESS			((u16)28)
-#define HOST_IF_MSG_GET_IPADDRESS			((u16)29)
-#define HOST_IF_MSG_FLUSH_CONNECT			((u16)30)
-#define HOST_IF_MSG_GET_STATISTICS				((u16)31)
-#define HOST_IF_MSG_SET_MULTICAST_FILTER		((u16)32)
-#define HOST_IF_MSG_ADD_BA_SESSION		((u16)33)
-#define HOST_IF_MSG_DEL_BA_SESSION		((u16)34)
-#define HOST_IF_MSG_Q_IDLE		((u16)35)
-#define HOST_IF_MSG_DEL_ALL_STA  ((u16)36)
-#define HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS		((u16)34)
-
-#define HOST_IF_MSG_EXIT					((u16)100)
-
-#define HOST_IF_SCAN_TIMEOUT		4000
-#define HOST_IF_CONNECT_TIMEOUT	9500
-
-#define BA_SESSION_DEFAULT_BUFFER_SIZE	16
-#define BA_SESSION_DEFAULT_TIMEOUT		1000
-#define BLOCK_ACK_REQ_SIZE 0x14
+#define HOST_IF_MSG_SCAN                        ((u16)0)
+#define HOST_IF_MSG_CONNECT                     ((u16)1)
+#define HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO        ((u16)2)
+#define HOST_IF_MSG_KEY                         ((u16)3)
+#define HOST_IF_MSG_RCVD_NTWRK_INFO             ((u16)4)
+#define HOST_IF_MSG_RCVD_SCAN_COMPLETE          ((u16)5)
+#define HOST_IF_MSG_CFG_PARAMS                  ((u16)6)
+#define HOST_IF_MSG_SET_CHANNEL                 ((u16)7)
+#define HOST_IF_MSG_DISCONNECT                  ((u16)8)
+#define HOST_IF_MSG_GET_RSSI                    ((u16)9)
+#define HOST_IF_MSG_GET_CHNL                    ((u16)10)
+#define HOST_IF_MSG_ADD_BEACON                  ((u16)11)
+#define HOST_IF_MSG_DEL_BEACON                  ((u16)12)
+#define HOST_IF_MSG_ADD_STATION                 ((u16)13)
+#define HOST_IF_MSG_DEL_STATION                 ((u16)14)
+#define HOST_IF_MSG_EDIT_STATION                ((u16)15)
+#define HOST_IF_MSG_SCAN_TIMER_FIRED            ((u16)16)
+#define HOST_IF_MSG_CONNECT_TIMER_FIRED         ((u16)17)
+#define HOST_IF_MSG_POWER_MGMT                  ((u16)18)
+#define HOST_IF_MSG_GET_INACTIVETIME            ((u16)19)
+#define HOST_IF_MSG_REMAIN_ON_CHAN              ((u16)20)
+#define HOST_IF_MSG_REGISTER_FRAME              ((u16)21)
+#define HOST_IF_MSG_LISTEN_TIMER_FIRED          ((u16)22)
+#define HOST_IF_MSG_GET_LINKSPEED               ((u16)23)
+#define HOST_IF_MSG_SET_WFIDRV_HANDLER          ((u16)24)
+#define HOST_IF_MSG_SET_MAC_ADDRESS             ((u16)25)
+#define HOST_IF_MSG_GET_MAC_ADDRESS             ((u16)26)
+#define HOST_IF_MSG_SET_OPERATION_MODE          ((u16)27)
+#define HOST_IF_MSG_SET_IPADDRESS               ((u16)28)
+#define HOST_IF_MSG_GET_IPADDRESS               ((u16)29)
+#define HOST_IF_MSG_FLUSH_CONNECT               ((u16)30)
+#define HOST_IF_MSG_GET_STATISTICS              ((u16)31)
+#define HOST_IF_MSG_SET_MULTICAST_FILTER        ((u16)32)
+#define HOST_IF_MSG_ADD_BA_SESSION              ((u16)33)
+#define HOST_IF_MSG_DEL_BA_SESSION              ((u16)34)
+#define HOST_IF_MSG_Q_IDLE                      ((u16)35)
+#define HOST_IF_MSG_DEL_ALL_STA                 ((u16)36)
+#define HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS      ((u16)34)
+#define HOST_IF_MSG_EXIT                        ((u16)100)
+
+#define HOST_IF_SCAN_TIMEOUT                    4000
+#define HOST_IF_CONNECT_TIMEOUT                 9500
+
+#define BA_SESSION_DEFAULT_BUFFER_SIZE          16
+#define BA_SESSION_DEFAULT_TIMEOUT              1000
+#define BLOCK_ACK_REQ_SIZE                      0x14
 /*****************************************************************************/
 /*								Type Definitions							 */
 /*****************************************************************************/
-- 
1.9.1

