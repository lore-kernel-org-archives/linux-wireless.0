Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33886 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbbFRNJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 09:09:06 -0400
Received: by pabvl15 with SMTP id vl15so15133891pab.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2015 06:09:06 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/2] staging: wilc1000: remove unnecessary typecast in #define macro
Date: Thu, 18 Jun 2015 22:08:51 +0900
Message-Id: <1434632931-16909-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150618_150915_572957_CF538DCB)
In-Reply-To: <1434632931-16909-1-git-send-email-chaehyun.lim@gmail.com>
References: <1434632931-16909-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecessary typecast in #define macro.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 78 +++++++++++++++----------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2cb2607..9469561 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -17,45 +17,45 @@ extern u8 g_wilc_initialized;
 /*****************************************************************************/
 
 /* Message types of the Host IF Message Queue*/
-#define HOST_IF_MSG_SCAN                        ((u16)0)
-#define HOST_IF_MSG_CONNECT                     ((u16)1)
-#define HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO        ((u16)2)
-#define HOST_IF_MSG_KEY                         ((u16)3)
-#define HOST_IF_MSG_RCVD_NTWRK_INFO             ((u16)4)
-#define HOST_IF_MSG_RCVD_SCAN_COMPLETE          ((u16)5)
-#define HOST_IF_MSG_CFG_PARAMS                  ((u16)6)
-#define HOST_IF_MSG_SET_CHANNEL                 ((u16)7)
-#define HOST_IF_MSG_DISCONNECT                  ((u16)8)
-#define HOST_IF_MSG_GET_RSSI                    ((u16)9)
-#define HOST_IF_MSG_GET_CHNL                    ((u16)10)
-#define HOST_IF_MSG_ADD_BEACON                  ((u16)11)
-#define HOST_IF_MSG_DEL_BEACON                  ((u16)12)
-#define HOST_IF_MSG_ADD_STATION                 ((u16)13)
-#define HOST_IF_MSG_DEL_STATION                 ((u16)14)
-#define HOST_IF_MSG_EDIT_STATION                ((u16)15)
-#define HOST_IF_MSG_SCAN_TIMER_FIRED            ((u16)16)
-#define HOST_IF_MSG_CONNECT_TIMER_FIRED         ((u16)17)
-#define HOST_IF_MSG_POWER_MGMT                  ((u16)18)
-#define HOST_IF_MSG_GET_INACTIVETIME            ((u16)19)
-#define HOST_IF_MSG_REMAIN_ON_CHAN              ((u16)20)
-#define HOST_IF_MSG_REGISTER_FRAME              ((u16)21)
-#define HOST_IF_MSG_LISTEN_TIMER_FIRED          ((u16)22)
-#define HOST_IF_MSG_GET_LINKSPEED               ((u16)23)
-#define HOST_IF_MSG_SET_WFIDRV_HANDLER          ((u16)24)
-#define HOST_IF_MSG_SET_MAC_ADDRESS             ((u16)25)
-#define HOST_IF_MSG_GET_MAC_ADDRESS             ((u16)26)
-#define HOST_IF_MSG_SET_OPERATION_MODE          ((u16)27)
-#define HOST_IF_MSG_SET_IPADDRESS               ((u16)28)
-#define HOST_IF_MSG_GET_IPADDRESS               ((u16)29)
-#define HOST_IF_MSG_FLUSH_CONNECT               ((u16)30)
-#define HOST_IF_MSG_GET_STATISTICS              ((u16)31)
-#define HOST_IF_MSG_SET_MULTICAST_FILTER        ((u16)32)
-#define HOST_IF_MSG_ADD_BA_SESSION              ((u16)33)
-#define HOST_IF_MSG_DEL_BA_SESSION              ((u16)34)
-#define HOST_IF_MSG_Q_IDLE                      ((u16)35)
-#define HOST_IF_MSG_DEL_ALL_STA                 ((u16)36)
-#define HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS      ((u16)34)
-#define HOST_IF_MSG_EXIT                        ((u16)100)
+#define HOST_IF_MSG_SCAN                        0
+#define HOST_IF_MSG_CONNECT                     1
+#define HOST_IF_MSG_RCVD_GNRL_ASYNC_INFO        2
+#define HOST_IF_MSG_KEY                         3
+#define HOST_IF_MSG_RCVD_NTWRK_INFO             4
+#define HOST_IF_MSG_RCVD_SCAN_COMPLETE          5
+#define HOST_IF_MSG_CFG_PARAMS                  6
+#define HOST_IF_MSG_SET_CHANNEL                 7
+#define HOST_IF_MSG_DISCONNECT                  8
+#define HOST_IF_MSG_GET_RSSI                    9
+#define HOST_IF_MSG_GET_CHNL                    10
+#define HOST_IF_MSG_ADD_BEACON                  11
+#define HOST_IF_MSG_DEL_BEACON                  12
+#define HOST_IF_MSG_ADD_STATION                 13
+#define HOST_IF_MSG_DEL_STATION                 14
+#define HOST_IF_MSG_EDIT_STATION                15
+#define HOST_IF_MSG_SCAN_TIMER_FIRED            16
+#define HOST_IF_MSG_CONNECT_TIMER_FIRED         17
+#define HOST_IF_MSG_POWER_MGMT                  18
+#define HOST_IF_MSG_GET_INACTIVETIME            19
+#define HOST_IF_MSG_REMAIN_ON_CHAN              20
+#define HOST_IF_MSG_REGISTER_FRAME              21
+#define HOST_IF_MSG_LISTEN_TIMER_FIRED          22
+#define HOST_IF_MSG_GET_LINKSPEED               23
+#define HOST_IF_MSG_SET_WFIDRV_HANDLER          24
+#define HOST_IF_MSG_SET_MAC_ADDRESS             25
+#define HOST_IF_MSG_GET_MAC_ADDRESS             26
+#define HOST_IF_MSG_SET_OPERATION_MODE          27
+#define HOST_IF_MSG_SET_IPADDRESS               28
+#define HOST_IF_MSG_GET_IPADDRESS               29
+#define HOST_IF_MSG_FLUSH_CONNECT               30
+#define HOST_IF_MSG_GET_STATISTICS              31
+#define HOST_IF_MSG_SET_MULTICAST_FILTER        32
+#define HOST_IF_MSG_ADD_BA_SESSION              33
+#define HOST_IF_MSG_DEL_BA_SESSION              34
+#define HOST_IF_MSG_Q_IDLE                      35
+#define HOST_IF_MSG_DEL_ALL_STA                 36
+#define HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS      34
+#define HOST_IF_MSG_EXIT                        100
 
 #define HOST_IF_SCAN_TIMEOUT                    4000
 #define HOST_IF_CONNECT_TIMEOUT                 9500
-- 
1.9.1

