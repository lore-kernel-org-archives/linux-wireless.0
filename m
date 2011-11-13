Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38007 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1KMIO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Nov 2011 03:14:59 -0500
Received: by ywt32 with SMTP id 32so1364804ywt.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Nov 2011 00:14:58 -0800 (PST)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH] NFC: Fix indentation in nci.h file
Date: Sun, 13 Nov 2011 10:14:30 +0200
Message-Id: <1321172070-26053-1-git-send-email-ilane@ti.com> (sfid-20111113_091511_198079_892B6D33)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Fix indentation in nci.h file.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 include/net/nfc/nci.h |   84 ++++++++++++++++++++++++------------------------
 1 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/include/net/nfc/nci.h b/include/net/nfc/nci.h
index cdbe671..b61eb6c 100644
--- a/include/net/nfc/nci.h
+++ b/include/net/nfc/nci.h
@@ -34,30 +34,30 @@
 #define NCI_MAX_NUM_CONN					10
 
 /* NCI Status Codes */
-#define	NCI_STATUS_OK						0x00
-#define	NCI_STATUS_REJECTED					0x01
-#define	NCI_STATUS_RF_FRAME_CORRUPTED				0x02
-#define	NCI_STATUS_FAILED					0x03
-#define	NCI_STATUS_NOT_INITIALIZED				0x04
-#define	NCI_STATUS_SYNTAX_ERROR					0x05
-#define	NCI_STATUS_SEMANTIC_ERROR				0x06
-#define	NCI_STATUS_UNKNOWN_GID					0x07
-#define	NCI_STATUS_UNKNOWN_OID					0x08
-#define	NCI_STATUS_INVALID_PARAM				0x09
-#define	NCI_STATUS_MESSAGE_SIZE_EXCEEDED			0x0a
+#define NCI_STATUS_OK						0x00
+#define NCI_STATUS_REJECTED					0x01
+#define NCI_STATUS_RF_FRAME_CORRUPTED				0x02
+#define NCI_STATUS_FAILED					0x03
+#define NCI_STATUS_NOT_INITIALIZED				0x04
+#define NCI_STATUS_SYNTAX_ERROR					0x05
+#define NCI_STATUS_SEMANTIC_ERROR				0x06
+#define NCI_STATUS_UNKNOWN_GID					0x07
+#define NCI_STATUS_UNKNOWN_OID					0x08
+#define NCI_STATUS_INVALID_PARAM				0x09
+#define NCI_STATUS_MESSAGE_SIZE_EXCEEDED			0x0a
 /* Discovery Specific Status Codes */
-#define	NCI_STATUS_DISCOVERY_ALREADY_STARTED			0xa0
-#define	NCI_STATUS_DISCOVERY_TARGET_ACTIVATION_FAILED		0xa1
-#define	NCI_STATUS_DISCOVERY_TEAR_DOWN				0xa2
+#define NCI_STATUS_DISCOVERY_ALREADY_STARTED			0xa0
+#define NCI_STATUS_DISCOVERY_TARGET_ACTIVATION_FAILED		0xa1
+#define NCI_STATUS_DISCOVERY_TEAR_DOWN				0xa2
 /* RF Interface Specific Status Codes */
-#define	NCI_STATUS_RF_TRANSMISSION_ERROR			0xb0
-#define	NCI_STATUS_RF_PROTOCOL_ERROR				0xb1
-#define	NCI_STATUS_RF_TIMEOUT_ERROR				0xb2
+#define NCI_STATUS_RF_TRANSMISSION_ERROR			0xb0
+#define NCI_STATUS_RF_PROTOCOL_ERROR				0xb1
+#define NCI_STATUS_RF_TIMEOUT_ERROR				0xb2
 /* NFCEE Interface Specific Status Codes */
-#define	NCI_STATUS_MAX_ACTIVE_NFCEE_INTERFACES_REACHED		0xc0
-#define	NCI_STATUS_NFCEE_INTERFACE_ACTIVATION_FAILED		0xc1
-#define	NCI_STATUS_NFCEE_TRANSMISSION_ERROR			0xc2
-#define	NCI_STATUS_NFCEE_PROTOCOL_ERROR				0xc3
+#define NCI_STATUS_MAX_ACTIVE_NFCEE_INTERFACES_REACHED		0xc0
+#define NCI_STATUS_NFCEE_INTERFACE_ACTIVATION_FAILED		0xc1
+#define NCI_STATUS_NFCEE_TRANSMISSION_ERROR			0xc2
+#define NCI_STATUS_NFCEE_PROTOCOL_ERROR				0xc3
 #define NCI_STATUS_NFCEE_TIMEOUT_ERROR				0xc4
 
 /* NCI RF Technology and Mode */
@@ -97,9 +97,9 @@
 
 /* NCI RF Interfaces */
 #define NCI_RF_INTERFACE_NFCEE_DIRECT				0x00
-#define	NCI_RF_INTERFACE_FRAME					0x01
-#define	NCI_RF_INTERFACE_ISO_DEP				0x02
-#define	NCI_RF_INTERFACE_NFC_DEP				0x03
+#define NCI_RF_INTERFACE_FRAME					0x01
+#define NCI_RF_INTERFACE_ISO_DEP				0x02
+#define NCI_RF_INTERFACE_NFC_DEP				0x03
 
 /* NCI Reset types */
 #define NCI_RESET_TYPE_KEEP_CONFIG				0x00
@@ -118,22 +118,22 @@
 
 /* NCI Discovery Types */
 #define NCI_DISCOVERY_TYPE_POLL_A_PASSIVE			0x00
-#define	NCI_DISCOVERY_TYPE_POLL_B_PASSIVE			0x01
-#define	NCI_DISCOVERY_TYPE_POLL_F_PASSIVE			0x02
-#define	NCI_DISCOVERY_TYPE_POLL_A_ACTIVE			0x03
-#define	NCI_DISCOVERY_TYPE_POLL_F_ACTIVE			0x05
-#define	NCI_DISCOVERY_TYPE_WAKEUP_A_ACTIVE			0x09
-#define	NCI_DISCOVERY_TYPE_LISTEN_A_PASSIVE			0x80
-#define	NCI_DISCOVERY_TYPE_LISTEN_B_PASSIVE			0x81
-#define	NCI_DISCOVERY_TYPE_LISTEN_F_PASSIVE			0x82
-#define	NCI_DISCOVERY_TYPE_LISTEN_A_ACTIVE			0x83
-#define	NCI_DISCOVERY_TYPE_LISTEN_F_ACTIVE			0x85
+#define NCI_DISCOVERY_TYPE_POLL_B_PASSIVE			0x01
+#define NCI_DISCOVERY_TYPE_POLL_F_PASSIVE			0x02
+#define NCI_DISCOVERY_TYPE_POLL_A_ACTIVE			0x03
+#define NCI_DISCOVERY_TYPE_POLL_F_ACTIVE			0x05
+#define NCI_DISCOVERY_TYPE_WAKEUP_A_ACTIVE			0x09
+#define NCI_DISCOVERY_TYPE_LISTEN_A_PASSIVE			0x80
+#define NCI_DISCOVERY_TYPE_LISTEN_B_PASSIVE			0x81
+#define NCI_DISCOVERY_TYPE_LISTEN_F_PASSIVE			0x82
+#define NCI_DISCOVERY_TYPE_LISTEN_A_ACTIVE			0x83
+#define NCI_DISCOVERY_TYPE_LISTEN_F_ACTIVE			0x85
 
 /* NCI Deactivation Type */
-#define	NCI_DEACTIVATE_TYPE_IDLE_MODE				0x00
-#define	NCI_DEACTIVATE_TYPE_SLEEP_MODE				0x01
-#define	NCI_DEACTIVATE_TYPE_SLEEP_AF_MODE			0x02
-#define	NCI_DEACTIVATE_TYPE_DISCOVERY				0x03
+#define NCI_DEACTIVATE_TYPE_IDLE_MODE				0x00
+#define NCI_DEACTIVATE_TYPE_SLEEP_MODE				0x01
+#define NCI_DEACTIVATE_TYPE_SLEEP_AF_MODE			0x02
+#define NCI_DEACTIVATE_TYPE_DISCOVERY				0x03
 
 /* Message Type (MT) */
 #define NCI_MT_DATA_PKT						0x00
@@ -165,10 +165,10 @@
 #define nci_conn_id(hdr)		(__u8)(((hdr)[0])&0x0f)
 
 /* GID values */
-#define	NCI_GID_CORE						0x0
-#define	NCI_GID_RF_MGMT						0x1
-#define	NCI_GID_NFCEE_MGMT					0x2
-#define	NCI_GID_PROPRIETARY					0xf
+#define NCI_GID_CORE						0x0
+#define NCI_GID_RF_MGMT						0x1
+#define NCI_GID_NFCEE_MGMT					0x2
+#define NCI_GID_PROPRIETARY					0xf
 
 /* ---- NCI Packet structures ---- */
 #define NCI_CTRL_HDR_SIZE					3
-- 
1.7.0.4

