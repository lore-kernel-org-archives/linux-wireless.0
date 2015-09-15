Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35718 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbbIOFH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:07:27 -0400
Received: by pacfv12 with SMTP id fv12so168235157pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:07:27 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 12/18] staging: wilc1000: fix alignment of defines
Date: Tue, 15 Sep 2015 14:06:22 +0900
Message-Id: <1442293588-15323-12-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_070736_834098_5186EED6)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fix alignment of defines.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.h | 42 +++++++++++++++----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index f15a878..64bcd80 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -20,11 +20,11 @@
 #define IDLE_MODE	0x00
 #define AP_MODE		0x01
 #define STATION_MODE	0x02
-#define GO_MODE	0x03
+#define GO_MODE		0x03
 #define CLIENT_MODE	0x04
 
 
-#define MAX_NUM_STA                 9
+#define MAX_NUM_STA				9
 #define ACTIVE_SCAN_TIME			10
 #define PASSIVE_SCAN_TIME			1200
 #define MIN_SCAN_TIME				10
@@ -34,31 +34,31 @@
 #define OBSS_PERIODIC_SCAN			BIT(1)
 #define OBSS_ONETIME_SCAN			BIT(2)
 #define GTK_RX_KEY_BUFF_LEN			24
-#define ADDKEY						0x1
-#define REMOVEKEY					0x2
-#define DEFAULTKEY					0x4
-#define ADDKEY_AP					0x8
-#define MAX_NUM_SCANNED_NETWORKS	100 /* 30		// rachel */
-#define MAX_NUM_SCANNED_NETWORKS_SHADOW	130
-#define MAX_NUM_PROBED_SSID            10  /*One more than the number of scanned ssids*/
+#define ADDKEY					0x1
+#define REMOVEKEY				0x2
+#define DEFAULTKEY				0x4
+#define ADDKEY_AP				0x8
+#define MAX_NUM_SCANNED_NETWORKS		100 /* 30		// rachel */
+#define MAX_NUM_SCANNED_NETWORKS_SHADOW		130
+#define MAX_NUM_PROBED_SSID			10  /*One more than the number of scanned ssids*/
 #define CHANNEL_SCAN_TIME			250 /* 250 */
 
 #define TX_MIC_KEY_LEN				8
 #define RX_MIC_KEY_LEN				8
-#define PTK_KEY_LEN					16
+#define PTK_KEY_LEN				16
 
 #define TX_MIC_KEY_MSG_LEN			26
 #define RX_MIC_KEY_MSG_LEN			48
 #define PTK_KEY_MSG_LEN				39
 
 #define PMKSA_KEY_LEN				22
-#define ETH_ALEN  6
-#define PMKID_LEN					16
-#define WILC_MAX_NUM_PMKIDS  16
-#define WILC_SUPP_MCS_SET_SIZE	16
-#define WILC_ADD_STA_LENGTH	40 /* Not including the rates field cause it has variable length*/
+#define ETH_ALEN				6
+#define PMKID_LEN				16
+#define WILC_MAX_NUM_PMKIDS			16
+#define WILC_SUPP_MCS_SET_SIZE			16
+#define WILC_ADD_STA_LENGTH			40 /* Not including the rates field cause it has variable length*/
 #define SCAN_EVENT_DONE_ABORTED
-#define NUM_CONCURRENT_IFC 2
+#define NUM_CONCURRENT_IFC			2
 
 typedef struct {
 	u16 cfg_wid;
@@ -304,11 +304,11 @@ typedef struct {
 } tstrHostIfRegisterFrame;
 
 
-#define   ACTION         0xD0
-#define   PROBE_REQ   0x40
-#define   PROBE_RESP  0x50
-#define   ACTION_FRM_IDX   0
-#define   PROBE_REQ_IDX     1
+#define ACTION			0xD0
+#define PROBE_REQ		0x40
+#define PROBE_RESP		0x50
+#define ACTION_FRM_IDX		0
+#define PROBE_REQ_IDX		1
 
 
 enum p2p_listen_state {
-- 
2.5.1

