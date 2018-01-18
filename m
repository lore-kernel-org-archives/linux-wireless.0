Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:7296 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756223AbeARNSH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 08:18:07 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 02/14] staging: wilc1000: removed unnecessary defined enums typedef
Date: Thu, 18 Jan 2018 18:47:00 +0530
Message-ID: <1516281432-7724-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180118_141832_024440_BE5ECE5D)
In-Reply-To: <1516281432-7724-1-git-send-email-ajay.kathat@microchip.com>
References: <1516281432-7724-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fix the "do not add new typedefs" issue found by checkpatch.pl
script

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 72 ++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 1641ddb..e186509 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -114,28 +114,28 @@ enum {
 	G_MIXED_11B_2_MODE,		/* 1,2,5,11,6,12,24 otherwise all on */
 };
 
-typedef enum {
+enum {
 	G_SHORT_PREAMBLE	= 0,	/* Short Preamble */
 	G_LONG_PREAMBLE		= 1,	/* Long Preamble */
 	G_AUTO_PREAMBLE		= 2,	/* Auto Preamble Selection */
-} G_PREAMBLE_T;
+};
 
 #define MAC_CONNECTED		1
 #define MAC_DISCONNECTED	0
 
 #define SCAN_DONE		TRUE
-typedef enum {
+enum {
 	PASSIVE_SCAN		= 0,
 	ACTIVE_SCAN		= 1,
-} SCANTYPE_T;
+};
 
-typedef enum {
+enum {
 	NO_POWERSAVE		= 0,
 	MIN_FAST_PS		= 1,
 	MAX_FAST_PS		= 2,
 	MIN_PSPOLL_PS		= 3,
 	MAX_PSPOLL_PS		= 4
-} USER_PS_MODE_T;
+};
 
 enum chip_ps_states {
 	CHIP_WAKEDUP		= 0,
@@ -153,7 +153,7 @@ enum bus_release {
 	RELEASE_ALLOW_SLEEP	= 1,
 };
 
-typedef enum {
+enum {
 	NO_SECURITY		= 0,
 	WEP_40			= 0x3,
 	WEP_104			= 0x7,
@@ -163,7 +163,7 @@ typedef enum {
 	WPA2_AES		= 0x31,
 	WPA2_TKIP		= 0x51,
 	WPA2_AES_TKIP		= 0x71,	/* Aes or Tkip */
-} SECURITY_T;
+};
 
 enum AUTHTYPE {
 	OPEN_SYSTEM		= 1,
@@ -178,88 +178,88 @@ enum SITESURVEY {
 	SITE_SURVEY_OFF		= 2
 };
 
-typedef enum {
+enum {
 	NORMAL_ACK		= 0,
 	NO_ACK,
-} ACK_POLICY_T;
+};
 
-typedef enum {
+enum {
 	DONT_RESET		= 0,
 	DO_RESET		= 1,
 	NO_REQUEST		= 2,
-} RESET_REQ_T;
+};
 
-typedef enum {
+enum {
 	REKEY_DISABLE		= 1,
 	REKEY_TIME_BASE,
 	REKEY_PKT_BASE,
 	REKEY_TIME_PKT_BASE
-} RSNA_REKEY_POLICY_T;
+};
 
-typedef enum {
+enum {
 	FILTER_NO		= 0x00,
 	FILTER_AP_ONLY		= 0x01,
 	FILTER_STA_ONLY		= 0x02
-} SCAN_CLASS_FITLER_T;
+};
 
-typedef enum {
+enum {
 	PRI_HIGH_RSSI		= 0x00,
 	PRI_LOW_RSSI		= 0x04,
 	PRI_DETECT		= 0x08
-} SCAN_PRI_T;
+};
 
-typedef enum {
+enum {
 	CH_FILTER_OFF		= 0x00,
 	CH_FILTER_ON		= 0x10
-} CH_FILTER_T;
+};
 
-typedef enum {
+enum {
 	AUTO_PROT		= 0,	/* Auto */
 	NO_PROT,			/* Do not use any protection */
 	ERP_PROT,			/* Protect all ERP frame exchanges */
 	HT_PROT,			/* Protect all HT frame exchanges  */
 	GF_PROT,			/* Protect all GF frame exchanges  */
-} N_PROTECTION_MODE_T;
+};
 
-typedef enum {
+enum {
 	G_SELF_CTS_PROT,
 	G_RTS_CTS_PROT,
-} G_PROTECTION_MODE_T;
+};
 
-typedef enum {
+enum {
 	HT_MIXED_MODE		= 1,
 	HT_ONLY_20MHZ_MODE,
 	HT_ONLY_20_40MHZ_MODE,
-} N_OPERATING_MODE_T;
+};
 
-typedef enum {
+enum {
 	NO_DETECT		= 0,
 	DETECT_ONLY		= 1,
 	DETECT_PROTECT		= 2,
 	DETECT_PROTECT_REPORT	= 3,
-} N_OBSS_DETECTION_T;
+};
 
-typedef enum {
+enum {
 	RTS_CTS_NONHT_PROT	= 0,	/* RTS-CTS at non-HT rate */
 	FIRST_FRAME_NONHT_PROT,		/* First frame at non-HT rate */
 	LSIG_TXOP_PROT,                 /* LSIG TXOP Protection */
 	FIRST_FRAME_MIXED_PROT,		/* First frame at Mixed format */
-} N_PROTECTION_TYPE_T;
+};
 
-typedef enum {
+enum {
 	STATIC_MODE		= 1,
 	DYNAMIC_MODE		= 2,
 	MIMO_MODE		= 3,	/* power save disable */
-} N_SMPS_MODE_T;
+};
 
-typedef enum {
+enum {
 	DISABLE_SELF_CTS,
 	ENABLE_SELF_CTS,
 	DISABLE_TX_ABORT,
 	ENABLE_TX_ABORT,
 	HW_TRIGGER_ABORT,
 	SW_TRIGGER_ABORT,
-} TX_ABORT_OPTION_T;
+};
 
 enum wid_type {
 	WID_CHAR		= 0,
@@ -281,7 +281,7 @@ struct wid {
 	s8 *val;
 };
 
-typedef enum {
+enum {
 	WID_NIL				= 0xffff,
 
 	/*
@@ -889,7 +889,7 @@ typedef enum {
 	/* Miscellaneous WIDs */
 	WID_ALL				= 0x7FFE,
 	WID_MAX				= 0xFFFF
-} WID_T;
+};
 
 struct wilc;
 int wilc_wlan_init(struct net_device *dev);
-- 
2.7.4
