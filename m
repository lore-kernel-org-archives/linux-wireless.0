Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34386 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbbFQH30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 03:29:26 -0400
Received: by pdbki1 with SMTP id ki1so32347941pdb.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2015 00:29:26 -0700 (PDT)
From: Sunghoon Cho <ywhsbliss@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	chris.park@atmel.com, Rachel.kim@atmel.com, dean.lee@atmel.com
Cc: Sunghoon Cho <ywhsbliss@gmail.com>
Subject: [PATCH 5/5] staging: wilc1000: align the line of enum data
Date: Wed, 17 Jun 2015 16:28:55 +0900
Message-Id: <56afaa1b2a30190f9f771b11ee99d9b328286972.1434526056.git.ywhsbliss@gmail.com> (sfid-20150617_092930_548124_D44E408B)
In-Reply-To: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
References: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
In-Reply-To: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
References: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch alignes the line of enumeration types.

Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 496 ++++++++++++++++----------------
 1 file changed, 248 insertions(+), 248 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 11a3b98..f07c08c 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -214,14 +214,14 @@ typedef struct {
 
 #ifdef WILC_PARSE_SCAN_IN_HOST
 typedef enum {
-	SUPP_RATES_IE = 1,
-	EXT_SUPP_RATES_IE = 50,
-	HT_CAPABILITY_IE = 45,
-	RSN_IE = 48,
-	WPA_IE = 221,
-	WMM_IE = 221,
+	SUPP_RATES_IE		= 1,
+	EXT_SUPP_RATES_IE	= 50,
+	HT_CAPABILITY_IE	= 45,
+	RSN_IE			= 48,
+	WPA_IE			= 221,
+	WMM_IE			= 221,
 	#ifdef WILC_P2P
-	P2P_IE = 221,
+	P2P_IE			= 221,
 	#endif
 } BEACON_IE;
 #endif
@@ -232,19 +232,19 @@ typedef enum {
 } BSSTYPE_T;
 
 typedef enum {
-	RATE_AUTO = 0,
-	RATE_1MB = 1,
-	RATE_2MB = 2,
-	RATE_5MB = 5,
-	RATE_6MB = 6,
-	RATE_9MB = 9,
-	RATE_11MB = 11,
-	RATE_12MB = 12,
-	RATE_18MB = 18,
-	RATE_24MB = 24,
-	RATE_26MB = 36,
-	RATE_48MB = 48,
-	RATE_54MB = 54
+	RATE_AUTO	= 0,
+	RATE_1MB	= 1,
+	RATE_2MB	= 2,
+	RATE_5MB	= 5,
+	RATE_6MB	= 6,
+	RATE_9MB	= 9,
+	RATE_11MB	= 11,
+	RATE_12MB	= 12,
+	RATE_18MB	= 18,
+	RATE_24MB	= 24,
+	RATE_26MB	= 36,
+	RATE_48MB	= 48,
+	RATE_54MB	= 54
 } TX_RATE_T;
 
 typedef enum {
@@ -259,9 +259,9 @@ typedef enum {
 } G_OPERATING_MODE_T;
 
 typedef enum {
-	G_SHORT_PREAMBLE = 0,	/* Short Preamble */
-	G_LONG_PREAMBLE  = 1,	/* Long Preamble */
-	G_AUTO_PREAMBLE  = 2,	/* Auto Preamble Selection */
+	G_SHORT_PREAMBLE	= 0,	/* Short Preamble */
+	G_LONG_PREAMBLE		= 1,	/* Long Preamble */
+	G_AUTO_PREAMBLE		= 2,	/* Auto Preamble Selection */
 } G_PREAMBLE_T;
 
 #define MAC_CONNECTED		1
@@ -270,57 +270,57 @@ typedef enum {
 /* bug3819: */
 #define SCAN_DONE		TRUE
 typedef enum {
-	PASSIVE_SCAN = 0,
-	ACTIVE_SCAN  = 1,
+	PASSIVE_SCAN	= 0,
+	ACTIVE_SCAN	= 1,
 } SCANTYPE_T;
 
 typedef enum {
-	NO_POWERSAVE     = 0,
-	MIN_FAST_PS      = 1,
-	MAX_FAST_PS      = 2,
-	MIN_PSPOLL_PS    = 3,
-	MAX_PSPOLL_PS    = 4
+	NO_POWERSAVE	= 0,
+	MIN_FAST_PS	= 1,
+	MAX_FAST_PS	= 2,
+	MIN_PSPOLL_PS	= 3,
+	MAX_PSPOLL_PS	= 4
 } USER_PS_MODE_T;
 
 typedef enum {
-	CHIP_WAKEDUP			= 0,
-	CHIP_SLEEPING_AUTO      = 1,
-	CHIP_SLEEPING_MANUAL  = 2
+	CHIP_WAKEDUP		= 0,
+	CHIP_SLEEPING_AUTO	= 1,
+	CHIP_SLEEPING_MANUAL	= 2
 } CHIP_PS_STATE_T;
 
 typedef enum {
-	ACQUIRE_ONLY                             = 0,
+	ACQUIRE_ONLY		= 0,
 	ACQUIRE_AND_WAKEUP	= 1,
 } BUS_ACQUIRE_T;
 
 typedef enum {
-	RELEASE_ONLY				= 0,
-	RELEASE_ALLOW_SLEEP		= 1,
+	RELEASE_ONLY		= 0,
+	RELEASE_ALLOW_SLEEP	= 1,
 } BUS_RELEASE_T;
 
 typedef enum {
-	NO_SECURITY = 0,
-	WEP_40 = 0x3,
-	WEP_104 = 0x7,
-	WPA_AES = 0x29,
-	WPA_TKIP = 0x49,
-	WPA_AES_TKIP = 0x69,	/* Aes or Tkip */
-	WPA2_AES = 0x31,
-	WPA2_TKIP = 0x51,
-	WPA2_AES_TKIP = 0x71,	/* Aes or Tkip */
+	NO_SECURITY	= 0,
+	WEP_40		= 0x3,
+	WEP_104		= 0x7,
+	WPA_AES		= 0x29,
+	WPA_TKIP	= 0x49,
+	WPA_AES_TKIP	= 0x69,	/* Aes or Tkip */
+	WPA2_AES	= 0x31,
+	WPA2_TKIP	= 0x51,
+	WPA2_AES_TKIP	= 0x71,	/* Aes or Tkip */
 } SECURITY_T;
 
 typedef enum {
-	OPEN_SYSTEM     = 1,
-	SHARED_KEY      = 2,
-	ANY				= 3,
-	IEEE8021 = 5
+	OPEN_SYSTEM	= 1,
+	SHARED_KEY	= 2,
+	ANY		= 3,
+	IEEE8021	= 5
 } AUTHTYPE_T;
 
 typedef enum {
-	SITE_SURVEY_1CH    = 0,
-	SITE_SURVEY_ALL_CH = 1,
-	SITE_SURVEY_OFF    = 2
+	SITE_SURVEY_1CH		= 0,
+	SITE_SURVEY_ALL_CH	= 1,
+	SITE_SURVEY_OFF		= 2
 } SITE_SURVEY_T;
 
 typedef enum {
@@ -329,33 +329,33 @@ typedef enum {
 } ACK_POLICY_T;
 
 typedef enum {
-	DONT_RESET = 0,
-	DO_RESET   = 1,
-	NO_REQUEST = 2,
+	DONT_RESET	= 0,
+	DO_RESET	= 1,
+	NO_REQUEST	= 2,
 } RESET_REQ_T;
 
 typedef enum {
-	REKEY_DISABLE = 1,
+	REKEY_DISABLE	= 1,
 	REKEY_TIME_BASE,
 	REKEY_PKT_BASE,
 	REKEY_TIME_PKT_BASE
 } RSNA_REKEY_POLICY_T;
 
 typedef enum {
-	FILTER_NO       = 0x00,
-	FILTER_AP_ONLY  = 0x01,
-	FILTER_STA_ONLY = 0x02
+	FILTER_NO	= 0x00,
+	FILTER_AP_ONLY	= 0x01,
+	FILTER_STA_ONLY	= 0x02
 } SCAN_CLASS_FITLER_T;
 
 typedef enum {
-	PRI_HIGH_RSSI    = 0x00,
-	PRI_LOW_RSSI     = 0x04,
-	PRI_DETECT       = 0x08
+	PRI_HIGH_RSSI	= 0x00,
+	PRI_LOW_RSSI	= 0x04,
+	PRI_DETECT	= 0x08
 } SCAN_PRI_T;
 
 typedef enum {
-	CH_FILTER_OFF    = 0x00,
-	CH_FILTER_ON     = 0x10
+	CH_FILTER_OFF	= 0x00,
+	CH_FILTER_ON	= 0x10
 } CH_FILTER_T;
 
 typedef enum {
@@ -378,10 +378,10 @@ typedef enum {
 } N_OPERATING_MODE_T;
 
 typedef enum {
-	NO_DETECT             = 0,
-	DETECT_ONLY           = 1,
-	DETECT_PROTECT        = 2,
-	DETECT_PROTECT_REPORT = 3,
+	NO_DETECT		= 0,
+	DETECT_ONLY		= 1,
+	DETECT_PROTECT		= 2,
+	DETECT_PROTECT_REPORT	= 3,
 } N_OBSS_DETECTION_T;
 
 typedef enum {
@@ -392,9 +392,9 @@ typedef enum {
 } N_PROTECTION_TYPE_T;
 
 typedef enum {
-	STATIC_MODE   = 1,
-	DYNAMIC_MODE  = 2,
-	MIMO_MODE     = 3,	/* power save disable */
+	STATIC_MODE	= 1,
+	DYNAMIC_MODE	= 2,
+	MIMO_MODE	= 3,	/* power save disable */
 } N_SMPS_MODE_T;
 
 typedef enum {
@@ -407,21 +407,21 @@ typedef enum {
 } TX_ABORT_OPTION_T;
 
 typedef enum {
-	WID_CHAR     = 0,
-	WID_SHORT    = 1,
-	WID_INT      = 2,
-	WID_STR      = 3,
-	WID_BIN_DATA = 4,
-	WID_BIN   = 5,
-	WID_IP    = 6,
-	WID_ADR   = 7,
-	WID_UNDEF = 8,
-	WID_TYPE_FORCE_32BIT  = 0xFFFFFFFF
+	WID_CHAR		= 0,
+	WID_SHORT		= 1,
+	WID_INT			= 2,
+	WID_STR			= 3,
+	WID_BIN_DATA		= 4,
+	WID_BIN			= 5,
+	WID_IP			= 6,
+	WID_ADR			= 7,
+	WID_UNDEF		= 8,
+	WID_TYPE_FORCE_32BIT	= 0xFFFFFFFF
 
 } WID_TYPE_T, tenuWIDtype;
 
 typedef enum {
-	WID_NIL                            = 0xffff,
+	WID_NIL				= 0xffff,
 
 	/*
 	 *  BSS Type
@@ -430,7 +430,7 @@ typedef enum {
 	 *  Values to set :         0               1            2
 	 *  --------------------------------------------------------------
 	 */
-	WID_BSS_TYPE						= 0x0000,
+	WID_BSS_TYPE			= 0x0000,
 
 	/*
 	 * Transmit Rate
@@ -439,7 +439,7 @@ typedef enum {
 	 * Values to set :  1  2  5    11  6  9  12  18  24  36  48  54
 	 * --------------------------------------------------------------
 	 */
-	WID_CURRENT_TX_RATE			= 0x0001,
+	WID_CURRENT_TX_RATE		= 0x0001,
 
 	/*
 	 * Channel
@@ -448,7 +448,7 @@ typedef enum {
 	 * Values to set    :  1  2  3  4  5  6  7  8   9   10  11  12  13  14
 	 * -------------------------------------------------------------------
 	 */
-	WID_CURRENT_CHANNEL			= 0x0002,
+	WID_CURRENT_CHANNEL		= 0x0002,
 
 	/*
 	 * Preamble
@@ -457,7 +457,7 @@ typedef enum {
 	 * Values to set :       0      1      2
 	 * --------------------------------------------------------------
 	 */
-	WID_PREAMBLE						= 0x0003,
+	WID_PREAMBLE			= 0x0003,
 
 	/*
 	 * 11g operating mode (ignored if 11g not present)
@@ -466,7 +466,7 @@ typedef enum {
 	 * Values to set :      1               2               3
 	 * --------------------------------------------------------------
 	 */
-	WID_11G_OPERATING_MODE            = 0x0004,
+	WID_11G_OPERATING_MODE		= 0x0004,
 
 	/*
 	 * Mac status (response only)
@@ -475,7 +475,7 @@ typedef enum {
 	 * Values to get :       0          1
 	 * --------------------------------------------------------------
 	 */
-	WID_STATUS						= 0x0005,
+	WID_STATUS			= 0x0005,
 
 	/*
 	 *  Scan type
@@ -484,7 +484,7 @@ typedef enum {
 	 * Values to set :                  0                 1
 	 * --------------------------------------------------------------
 	 */
-	WID_SCAN_TYPE                      = 0x0007,
+	WID_SCAN_TYPE			= 0x0007,
 
 	/*
 	 * Key Id (WEP default key Id)
@@ -493,7 +493,7 @@ typedef enum {
 	 * Values to set :	Same value. Default is 0
 	 * --------------------------------------------------------------
 	 */
-	WID_KEY_ID                         = 0x0009,
+	WID_KEY_ID			= 0x0009,
 
 	/*
 	 *  QoS Enable
@@ -502,7 +502,7 @@ typedef enum {
 	 *  Values to set :   0             1
 	 *  --------------------------------------------------------------
 	 */
-	WID_QOS_ENABLE                     = 0x000A,
+	WID_QOS_ENABLE			= 0x000A,
 
 	/*
 	 *  Power Management
@@ -511,7 +511,7 @@ typedef enum {
 	 *  Values to set :   0              1               2
 	 *  ----------------------------------------------------------------
 	 */
-	WID_POWER_MANAGEMENT               = 0x000B,
+	WID_POWER_MANAGEMENT		= 0x000B,
 
 	/*
 	 *  WEP/802 11I Configuration
@@ -523,7 +523,7 @@ typedef enum {
 	 *  Values (0x)   :      69          71
 	 *  ------------------------------------------------------------------
 	 */
-	WID_11I_MODE                       = 0x000C,
+	WID_11I_MODE			= 0x000C,
 
 	/*
 	 *  WEP Configuration: Used in BSS STA mode only when WEP is enabled
@@ -532,7 +532,7 @@ typedef enum {
 	 *  Values (0x)   :    01             02         03    |      BIT2
 	 *  ------------------------------------------------------------------
 	 */
-	WID_AUTH_TYPE                      = 0x000D,
+	WID_AUTH_TYPE			= 0x000D,
 
 	/*
 	 *  Site Survey Type
@@ -543,7 +543,7 @@ typedef enum {
 	 *  Disable Site Survey :  2
 	 *  --------------------------------------------------------------
 	 */
-	WID_SITE_SURVEY                    = 0x000E,
+	WID_SITE_SURVEY			= 0x000E,
 
 	/*
 	 *  Listen Interval
@@ -552,7 +552,7 @@ typedef enum {
 	 *  Values to set :   Same value. Default is 3
 	 *  --------------------------------------------------------------
 	 */
-	WID_LISTEN_INTERVAL                = 0x000F,
+	WID_LISTEN_INTERVAL		= 0x000F,
 
 	/*
 	 *  DTIM Period
@@ -561,7 +561,7 @@ typedef enum {
 	 *  Values to set :   Same value. Default is 3
 	 *  --------------------------------------------------------------
 	 */
-	WID_DTIM_PERIOD                    = 0x0010,
+	WID_DTIM_PERIOD			= 0x0010,
 
 	/*
 	 * ACK Policy
@@ -570,7 +570,7 @@ typedef enum {
 	 * Values to set :       0                   1
 	 * --------------------------------------------------------------
 	 */
-	WID_ACK_POLICY                     = 0x0011,
+	WID_ACK_POLICY			= 0x0011,
 
 	/*
 	 * Reset MAC (Set only)
@@ -579,7 +579,7 @@ typedef enum {
 	 * Values to set :       0                   1			2
 	 * --------------------------------------------------------------
 	 */
-	WID_RESET                          = 0x0012,
+	WID_RESET			= 0x0012,
 
 	/*
 	 * Broadcast SSID Option: Setting this will adhere to "" SSID element
@@ -588,7 +588,7 @@ typedef enum {
 	 * Values to set :   1                  0
 	 * ------------------------------------------------------------------
 	 */
-	WID_BCAST_SSID                     = 0x0015,
+	WID_BCAST_SSID			= 0x0015,
 
 	/*
 	 * Disconnect (Station)
@@ -597,7 +597,7 @@ typedef enum {
 	 * Values to set :   Association ID
 	 * ------------------------------------------------------------------
 	 */
-	WID_DISCONNECT                     = 0x0016,
+	WID_DISCONNECT			= 0x0016,
 
 	/*
 	 * 11a Tx Power Level
@@ -606,7 +606,7 @@ typedef enum {
 	 * Values to set : Any value between 0 and 63 (inclusive; Default is 48)
 	 * --------------------------------------------------------------------
 	 */
-	WID_TX_POWER_LEVEL_11A             = 0x0018,
+	WID_TX_POWER_LEVEL_11A		= 0x0018,
 
 	/*
 	 * Group Key Update Policy Selection
@@ -615,7 +615,7 @@ typedef enum {
 	 * Values to set :   1            2          3               4
 	 * --------------------------------------------------------------------
 	 */
-	WID_REKEY_POLICY                   = 0x0019,
+	WID_REKEY_POLICY		= 0x0019,
 
 	/*
 	 * Allow Short Slot
@@ -625,9 +625,9 @@ typedef enum {
 	 * Values to set :         0                       1
 	 * --------------------------------------------------------------
 	 */
-	WID_SHORT_SLOT_ALLOWED             = 0x001A,
+	WID_SHORT_SLOT_ALLOWED		= 0x001A,
 
-	WID_PHY_ACTIVE_REG                 = 0x001B,
+	WID_PHY_ACTIVE_REG		= 0x001B,
 
 	/*
 	 * 11b Tx Power Level
@@ -636,7 +636,7 @@ typedef enum {
 	 * Values to set : Any value between 0 and 63 (inclusive; Default is 48)
 	 * --------------------------------------------------------------------
 	 */
-	WID_TX_POWER_LEVEL_11B             = 0x001D,
+	WID_TX_POWER_LEVEL_11B		= 0x001D,
 
 	/*
 	 * Scan Request
@@ -645,7 +645,7 @@ typedef enum {
 	 * Values to set : 0
 	 * --------------------------------------------------------------------
 	 */
-	WID_START_SCAN_REQ                 = 0x001E,
+	WID_START_SCAN_REQ		= 0x001E,
 
 	/*
 	 * Rssi (get only)
@@ -654,7 +654,7 @@ typedef enum {
 	 * Values to get : Rssi value
 	 * --------------------------------------------------------------------
 	 */
-	WID_RSSI                           = 0x001F,
+	WID_RSSI			= 0x001F,
 
 	/*
 	 * Join Request
@@ -663,9 +663,9 @@ typedef enum {
 	 * Values to set : index of scan result
 	 * --------------------------------------------------------------------
 	 */
-	WID_JOIN_REQ                       = 0x0020,
+	WID_JOIN_REQ			= 0x0020,
 
-	WID_LINKSPEED				= 0x0026,
+	WID_LINKSPEED			= 0x0026,
 
 	/*
 	 * Enable User Control of TX Power
@@ -674,9 +674,9 @@ typedef enum {
 	 * Values to set :    0                       1
 	 * --------------------------------------------------------------------
 	 */
-	WID_USER_CONTROL_ON_TX_POWER       = 0x0027,
+	WID_USER_CONTROL_ON_TX_POWER	= 0x0027,
 
-	WID_MEMORY_ACCESS_8BIT             = 0x0029,
+	WID_MEMORY_ACCESS_8BIT		= 0x0029,
 
 	/*
 	 * Enable Auto RX Sensitivity feature
@@ -685,7 +685,7 @@ typedef enum {
 	 * Values to set :    0                       1
 	 * --------------------------------------------------------------------
 	 */
-	WID_AUTO_RX_SENSITIVITY            = 0x0032,
+	WID_AUTO_RX_SENSITIVITY		= 0x0032,
 
 	/*
 	 * Receive Buffer Based Ack
@@ -694,7 +694,7 @@ typedef enum {
 	 * Values to set :    0                       1
 	 * --------------------------------------------------------------------
 	 */
-	WID_DATAFLOW_CONTROL               = 0x0033,
+	WID_DATAFLOW_CONTROL		= 0x0033,
 
 	/*
 	 * Scan Filter
@@ -707,7 +707,7 @@ typedef enum {
 	 * Values to set :               0        0x10
 	 * --------------------------------------------------------------------
 	 */
-	WID_SCAN_FILTER                    = 0x0036,
+	WID_SCAN_FILTER			= 0x0036,
 
 	/*
 	 * Link Loss Threshold (measure in the beacon period)
@@ -717,13 +717,13 @@ typedef enum {
 	 * Values to set : Same value. Default is 10
 	 * --------------------------------------------------------------------
 	 */
-	WID_LINK_LOSS_THRESHOLD            = 0x0037,
+	WID_LINK_LOSS_THRESHOLD		= 0x0037,
 
 	/* BugID_4978 */
-	WID_ABORT_RUNNING_SCAN = 0x003E,
+	WID_ABORT_RUNNING_SCAN		= 0x003E,
 
 	/* NMAC Character WID list */
-	WID_WPS_START                      = 0x0043,
+	WID_WPS_START			= 0x0043,
 
 	/*
 	 * Protection mode for MAC
@@ -732,7 +732,7 @@ typedef enum {
 	 * Values to set :  0     1              2      3     4
 	 * --------------------------------------------------------------
 	 */
-	WID_11N_PROT_MECH                  = 0x0080,
+	WID_11N_PROT_MECH		= 0x0080,
 
 	/*
 	 * ERP Protection type for MAC
@@ -741,7 +741,7 @@ typedef enum {
 	 * Values to set :  0          1
 	 * --------------------------------------------------------------
 	 */
-	WID_11N_ERP_PROT_TYPE              = 0x0081,
+	WID_11N_ERP_PROT_TYPE		= 0x0081,
 
 	/*
 	 * HT Option Enable
@@ -750,7 +750,7 @@ typedef enum {
 	 * Values to set :   1                  0
 	 * --------------------------------------------------------------
 	 */
-	WID_11N_ENABLE                     = 0x0082,
+	WID_11N_ENABLE			= 0x0082,
 
 	/*
 	 * 11n Operating mode (Note that 11g operating mode will also be
@@ -760,7 +760,7 @@ typedef enum {
 	 * Values to set :     1         2               3
 	 * --------------------------------------------------------------
 	 */
-	WID_11N_OPERATING_MODE             = 0x0083,
+	WID_11N_OPERATING_MODE		= 0x0083,
 
 	/*
 	 * 11n OBSS non-HT STA Detection flag
@@ -775,7 +775,7 @@ typedef enum {
 	 * Values to set :  3
 	 * --------------------------------------------------------------
 	 */
-	WID_11N_OBSS_NONHT_DETECTION       = 0x0084,
+	WID_11N_OBSS_NONHT_DETECTION	= 0x0084,
 
 	/*
 	 * 11n HT Protection Type
@@ -786,7 +786,7 @@ typedef enum {
 	 * Values to set :  2         3
 	 * --------------------------------------------------------------
 	 */
-	WID_11N_HT_PROT_TYPE               = 0x0085,
+	WID_11N_HT_PROT_TYPE		= 0x0085,
 
 	/*
 	 * 11n RIFS Protection Enable Flag
@@ -795,7 +795,7 @@ typedef enum {
 	 * Values to set :  0          1
 	 * --------------------------------------------------------------
 	 */
-	WID_11N_RIFS_PROT_ENABLE           = 0x0086,
+	WID_11N_RIFS_PROT_ENABLE	= 0x0086,
 
 	/*
 	 * SMPS Mode
@@ -804,7 +804,7 @@ typedef enum {
 	 * Values to set :  1        2         3
 	 * --------------------------------------------------------------
 	 */
-	WID_11N_SMPS_MODE                  = 0x0087,
+	WID_11N_SMPS_MODE		= 0x0087,
 
 	/*
 	 * Current transmit MCS
@@ -813,9 +813,9 @@ typedef enum {
 	 * Values to set :  0 to 7
 	 * --------------------------------------------------------------
 	 */
-	WID_11N_CURRENT_TX_MCS             = 0x0088,
+	WID_11N_CURRENT_TX_MCS		= 0x0088,
 
-	WID_11N_PRINT_STATS                = 0x0089,
+	WID_11N_PRINT_STATS		= 0x0089,
 
 	/*
 	 * 11n Short GI Enable Flag
@@ -824,7 +824,7 @@ typedef enum {
 	 * Values to set :  0          1
 	 * --------------------------------------------------------------
 	 */
-	WID_11N_SHORT_GI_ENABLE            = 0x008D,
+	WID_11N_SHORT_GI_ENABLE		= 0x008D,
 
 	/*
 	 * 11n RIFS Enable Flag
@@ -833,7 +833,7 @@ typedef enum {
 	 * Values to set :  0          1
 	 * --------------------------------------------------------------
 	 */
-	WID_RIFS_MODE                      = 0x0094,
+	WID_RIFS_MODE			= 0x0094,
 
 	/*
 	 * TX Abort Feature
@@ -846,15 +846,15 @@ typedef enum {
 	 * Values to set :             4                                       5
 	 * --------------------------------------------------------------
 	 */
-	WID_TX_ABORT_CONFIG                = 0x00A1,
+	WID_TX_ABORT_CONFIG		= 0x00A1,
 
-	WID_REG_TSSI_11B_VALUE             = 0x00A6,
-	WID_REG_TSSI_11G_VALUE             = 0x00A7,
-	WID_REG_TSSI_11N_VALUE             = 0x00A8,
-	WID_TX_CALIBRATION                 = 0x00A9,
-	WID_DSCR_TSSI_11B_VALUE            = 0x00AA,
-	WID_DSCR_TSSI_11G_VALUE            = 0x00AB,
-	WID_DSCR_TSSI_11N_VALUE            = 0x00AC,
+	WID_REG_TSSI_11B_VALUE		= 0x00A6,
+	WID_REG_TSSI_11G_VALUE		= 0x00A7,
+	WID_REG_TSSI_11N_VALUE		= 0x00A8,
+	WID_TX_CALIBRATION		= 0x00A9,
+	WID_DSCR_TSSI_11B_VALUE		= 0x00AA,
+	WID_DSCR_TSSI_11G_VALUE		= 0x00AB,
+	WID_DSCR_TSSI_11N_VALUE		= 0x00AC,
 
 	/*
 	 * Immediate Block-Ack Support
@@ -863,7 +863,7 @@ typedef enum {
 	 * Values to set :    0                       1
 	 * --------------------------------------------------------------
 	 */
-	WID_11N_IMMEDIATE_BA_ENABLED       = 0x00AF,
+	WID_11N_IMMEDIATE_BA_ENABLED	= 0x00AF,
 
 	/*
 	 * TXOP Disable Flag
@@ -872,21 +872,21 @@ typedef enum {
 	 * Values to set :    1                        0
 	 * --------------------------------------------------------------
 	 */
-	WID_11N_TXOP_PROT_DISABLE          = 0x00B0,
+	WID_11N_TXOP_PROT_DISABLE	= 0x00B0,
 
-	WID_TX_POWER_LEVEL_11N             = 0x00B1,
+	WID_TX_POWER_LEVEL_11N		= 0x00B1,
 
 	/* Custom Character WID list */
-	WID_PC_TEST_MODE          = 0x00C8,
+	WID_PC_TEST_MODE		= 0x00C8,
 	/* bug3819: */
 	/* SCAN Complete notification WID */
 	WID_SCAN_COMPLETE		= 0x00C9,
 
 #ifdef WILC_AP_EXTERNAL_MLME
-	WID_DEL_BEACON					= 0x00CA,
+	WID_DEL_BEACON			= 0x00CA,
 #endif
 
-	WID_LOGTerminal_Switch					= 0x00CD,
+	WID_LOGTerminal_Switch		= 0x00CD,
 	/*
 	 * EMAC Short WID list
 	 * RTS Threshold
@@ -895,7 +895,7 @@ typedef enum {
 	 * Values to set :   Same value. Default is 2347
 	 * --------------------------------------------------------------
 	 */
-	WID_RTS_THRESHOLD                  = 0x1000,
+	WID_RTS_THRESHOLD		= 0x1000,
 
 	/*
 	 *  Fragmentation Threshold
@@ -904,149 +904,149 @@ typedef enum {
 	 *  Values to set :   Same value. Default is 2346
 	 *  --------------------------------------------------------------
 	 */
-	WID_FRAG_THRESHOLD                 = 0x1001,
-
-	WID_SHORT_RETRY_LIMIT              = 0x1002,
-	WID_LONG_RETRY_LIMIT               = 0x1003,
-	WID_BEACON_INTERVAL                = 0x1006,
-	WID_MEMORY_ACCESS_16BIT            = 0x1008,
-	WID_RX_SENSE                       = 0x100B,
-	WID_ACTIVE_SCAN_TIME               = 0x100C,
-	WID_PASSIVE_SCAN_TIME              = 0x100D,
-
-	WID_SITE_SURVEY_SCAN_TIME          = 0x100E,
-	WID_JOIN_START_TIMEOUT             = 0x100F,
-	WID_AUTH_TIMEOUT                   = 0x1010,
-	WID_ASOC_TIMEOUT                   = 0x1011,
-	WID_11I_PROTOCOL_TIMEOUT           = 0x1012,
-	WID_EAPOL_RESPONSE_TIMEOUT         = 0x1013,
+	WID_FRAG_THRESHOLD		= 0x1001,
+
+	WID_SHORT_RETRY_LIMIT		= 0x1002,
+	WID_LONG_RETRY_LIMIT		= 0x1003,
+	WID_BEACON_INTERVAL		= 0x1006,
+	WID_MEMORY_ACCESS_16BIT		= 0x1008,
+	WID_RX_SENSE			= 0x100B,
+	WID_ACTIVE_SCAN_TIME		= 0x100C,
+	WID_PASSIVE_SCAN_TIME		= 0x100D,
+
+	WID_SITE_SURVEY_SCAN_TIME	= 0x100E,
+	WID_JOIN_START_TIMEOUT		= 0x100F,
+	WID_AUTH_TIMEOUT		= 0x1010,
+	WID_ASOC_TIMEOUT		= 0x1011,
+	WID_11I_PROTOCOL_TIMEOUT	= 0x1012,
+	WID_EAPOL_RESPONSE_TIMEOUT	= 0x1013,
 
 	/* NMAC Short WID list */
-	WID_11N_SIG_QUAL_VAL               = 0x1085,
-	WID_CCA_THRESHOLD                  = 0x1087,
+	WID_11N_SIG_QUAL_VAL		= 0x1085,
+	WID_CCA_THRESHOLD		= 0x1087,
 
 	/* Custom Short WID list */
 
 	/* EMAC Integer WID list */
-	WID_FAILED_COUNT                   = 0x2000,
-	WID_RETRY_COUNT                    = 0x2001,
-	WID_MULTIPLE_RETRY_COUNT           = 0x2002,
-	WID_FRAME_DUPLICATE_COUNT          = 0x2003,
-	WID_ACK_FAILURE_COUNT              = 0x2004,
-	WID_RECEIVED_FRAGMENT_COUNT        = 0x2005,
-	WID_MCAST_RECEIVED_FRAME_COUNT     = 0x2006,
-	WID_FCS_ERROR_COUNT                = 0x2007,
-	WID_SUCCESS_FRAME_COUNT            = 0x2008,
-	WID_HUT_TX_COUNT                   = 0x200A,
-	WID_TX_FRAGMENT_COUNT              = 0x200B,
-	WID_TX_MULTICAST_FRAME_COUNT       = 0x200C,
-	WID_RTS_SUCCESS_COUNT              = 0x200D,
-	WID_RTS_FAILURE_COUNT              = 0x200E,
-	WID_WEP_UNDECRYPTABLE_COUNT        = 0x200F,
-	WID_REKEY_PERIOD                   = 0x2010,
-	WID_REKEY_PACKET_COUNT             = 0x2011,
-	WID_1X_SERV_ADDR                   = 0x2012,
-	WID_STACK_IP_ADDR                  = 0x2013,
-	WID_STACK_NETMASK_ADDR             = 0x2014,
-	WID_HW_RX_COUNT                    = 0x2015,
-	WID_MEMORY_ADDRESS                 = 0x201E,
-	WID_MEMORY_ACCESS_32BIT            = 0x201F,
-	WID_RF_REG_VAL                     = 0x2021,
+	WID_FAILED_COUNT		= 0x2000,
+	WID_RETRY_COUNT			= 0x2001,
+	WID_MULTIPLE_RETRY_COUNT	= 0x2002,
+	WID_FRAME_DUPLICATE_COUNT	= 0x2003,
+	WID_ACK_FAILURE_COUNT		= 0x2004,
+	WID_RECEIVED_FRAGMENT_COUNT	= 0x2005,
+	WID_MCAST_RECEIVED_FRAME_COUNT	= 0x2006,
+	WID_FCS_ERROR_COUNT		= 0x2007,
+	WID_SUCCESS_FRAME_COUNT		= 0x2008,
+	WID_HUT_TX_COUNT		= 0x200A,
+	WID_TX_FRAGMENT_COUNT		= 0x200B,
+	WID_TX_MULTICAST_FRAME_COUNT	= 0x200C,
+	WID_RTS_SUCCESS_COUNT		= 0x200D,
+	WID_RTS_FAILURE_COUNT		= 0x200E,
+	WID_WEP_UNDECRYPTABLE_COUNT	= 0x200F,
+	WID_REKEY_PERIOD		= 0x2010,
+	WID_REKEY_PACKET_COUNT		= 0x2011,
+	WID_1X_SERV_ADDR		= 0x2012,
+	WID_STACK_IP_ADDR		= 0x2013,
+	WID_STACK_NETMASK_ADDR		= 0x2014,
+	WID_HW_RX_COUNT			= 0x2015,
+	WID_MEMORY_ADDRESS		= 0x201E,
+	WID_MEMORY_ACCESS_32BIT		= 0x201F,
+	WID_RF_REG_VAL			= 0x2021,
 
 	/* NMAC Integer WID list */
-	WID_11N_PHY_ACTIVE_REG_VAL         = 0x2080,
+	WID_11N_PHY_ACTIVE_REG_VAL	= 0x2080,
 
 	/* Custom Integer WID list */
-	WID_GET_INACTIVE_TIME     = 0x2084,
-	WID_SET_DRV_HANDLER =		 0X2085,
-	WID_SET_OPERATION_MODE =	 0X2086,
+	WID_GET_INACTIVE_TIME		= 0x2084,
+	WID_SET_DRV_HANDLER		= 0X2085,
+	WID_SET_OPERATION_MODE		= 0X2086,
 	/* EMAC String WID list */
-	WID_SSID                           = 0x3000,
-	WID_FIRMWARE_VERSION               = 0x3001,
-	WID_OPERATIONAL_RATE_SET           = 0x3002,
-	WID_BSSID                          = 0x3003,
-	WID_WEP_KEY_VALUE                  = 0x3004,
-	WID_11I_PSK                        = 0x3008,
-	WID_11E_P_ACTION_REQ               = 0x3009,
-	WID_1X_KEY                         = 0x300A,
-	WID_HARDWARE_VERSION               = 0x300B,
-	WID_MAC_ADDR                       = 0x300C,
-	WID_HUT_DEST_ADDR                  = 0x300D,
-	WID_PHY_VERSION                    = 0x300F,
-	WID_SUPP_USERNAME                  = 0x3010,
-	WID_SUPP_PASSWORD                  = 0x3011,
-	WID_SITE_SURVEY_RESULTS            = 0x3012,
-	WID_RX_POWER_LEVEL                 = 0x3013,
-	WID_DEL_ALL_RX_BA				= 0x3014,
-	WID_SET_STA_MAC_INACTIVE_TIME   = 0x3017,
-	WID_ADD_WEP_KEY                    = 0x3019,
-	WID_REMOVE_WEP_KEY                 = 0x301A,
-	WID_ADD_PTK                        = 0x301B,
-	WID_ADD_RX_GTK                     = 0x301C,
-	WID_ADD_TX_GTK                     = 0x301D,
-	WID_REMOVE_KEY                     = 0x301E,
-	WID_ASSOC_REQ_INFO                 = 0x301F,
-	WID_ASSOC_RES_INFO                 = 0x3020,
-	WID_MANUFACTURER                   = 0x3026, /* Added for CAPI tool */
-	WID_MODEL_NAME                     = 0x3027, /* Added for CAPI tool */
-	WID_MODEL_NUM                      = 0x3028, /* Added for CAPI tool */
-	WID_DEVICE_NAME                    = 0x3029, /* Added for CAPI tool */
+	WID_SSID			= 0x3000,
+	WID_FIRMWARE_VERSION		= 0x3001,
+	WID_OPERATIONAL_RATE_SET	= 0x3002,
+	WID_BSSID			= 0x3003,
+	WID_WEP_KEY_VALUE		= 0x3004,
+	WID_11I_PSK			= 0x3008,
+	WID_11E_P_ACTION_REQ		= 0x3009,
+	WID_1X_KEY			= 0x300A,
+	WID_HARDWARE_VERSION		= 0x300B,
+	WID_MAC_ADDR			= 0x300C,
+	WID_HUT_DEST_ADDR		= 0x300D,
+	WID_PHY_VERSION			= 0x300F,
+	WID_SUPP_USERNAME		= 0x3010,
+	WID_SUPP_PASSWORD		= 0x3011,
+	WID_SITE_SURVEY_RESULTS		= 0x3012,
+	WID_RX_POWER_LEVEL		= 0x3013,
+	WID_DEL_ALL_RX_BA		= 0x3014,
+	WID_SET_STA_MAC_INACTIVE_TIME	= 0x3017,
+	WID_ADD_WEP_KEY			= 0x3019,
+	WID_REMOVE_WEP_KEY		= 0x301A,
+	WID_ADD_PTK			= 0x301B,
+	WID_ADD_RX_GTK			= 0x301C,
+	WID_ADD_TX_GTK			= 0x301D,
+	WID_REMOVE_KEY			= 0x301E,
+	WID_ASSOC_REQ_INFO		= 0x301F,
+	WID_ASSOC_RES_INFO		= 0x3020,
+	WID_MANUFACTURER		= 0x3026, /* Added for CAPI tool */
+	WID_MODEL_NAME			= 0x3027, /* Added for CAPI tool */
+	WID_MODEL_NUM			= 0x3028, /* Added for CAPI tool */
+	WID_DEVICE_NAME			= 0x3029, /* Added for CAPI tool */
 
 	/* NMAC String WID list */
-	WID_11N_P_ACTION_REQ               = 0x3080,
-	WID_HUT_TEST_ID                    = 0x3081,
-	WID_PMKID_INFO                     = 0x3082,
-	WID_FIRMWARE_INFO                  = 0x3083,
+	WID_11N_P_ACTION_REQ		= 0x3080,
+	WID_HUT_TEST_ID			= 0x3081,
+	WID_PMKID_INFO			= 0x3082,
+	WID_FIRMWARE_INFO		= 0x3083,
 	#ifdef WILC_P2P
-	WID_REGISTER_FRAME                = 0x3084,
+	WID_REGISTER_FRAME		= 0x3084,
 	#endif
-	WID_DEL_ALL_STA          = 0x3085,
+	WID_DEL_ALL_STA			= 0x3085,
 	 #ifdef WILC_P2P
-	WID_REMAIN_ON_CHAN  = 0x3996,
+	WID_REMAIN_ON_CHAN		= 0x3996,
 	#endif
 	/* BugID_4156 */
-	WID_SSID_PROBE_REQ = 0x3997,
+	WID_SSID_PROBE_REQ		= 0x3997,
 	/*
 	 * BugID_4124 WID to trigger modified Join Request using SSID and
 	 * BSSID instead of bssListIdx (used by WID_JOIN_REQ)
 	 */
-	WID_JOIN_REQ_EXTENDED		 = 0x3998,
+	WID_JOIN_REQ_EXTENDED		= 0x3998,
 
 	/* BugID 4951: WID toset IP address in firmware */
-	WID_IP_ADDRESS					= 0x3999,
+	WID_IP_ADDRESS			= 0x3999,
 
 	/* Custom String WID list */
 
 	/* EMAC Binary WID list */
-	WID_UAPSD_CONFIG                   = 0x4001,
-	WID_UAPSD_STATUS                   = 0x4002,
-	WID_WMM_AP_AC_PARAMS               = 0x4003,
-	WID_WMM_STA_AC_PARAMS              = 0x4004,
-	WID_NETWORK_INFO                   = 0x4005,
-	WID_STA_JOIN_INFO                  = 0x4006,
-	WID_CONNECTED_STA_LIST             = 0x4007,
+	WID_UAPSD_CONFIG		= 0x4001,
+	WID_UAPSD_STATUS		= 0x4002,
+	WID_WMM_AP_AC_PARAMS		= 0x4003,
+	WID_WMM_STA_AC_PARAMS		= 0x4004,
+	WID_NETWORK_INFO		= 0x4005,
+	WID_STA_JOIN_INFO		= 0x4006,
+	WID_CONNECTED_STA_LIST		= 0x4007,
 
 	/* NMAC Binary WID list */
-	WID_11N_AUTORATE_TABLE             = 0x4080,
+	WID_11N_AUTORATE_TABLE		= 0x4080,
 
 	/* Added here by Amr - BugID 4134 */
-	WID_SCAN_CHANNEL_LIST                      = 0x4084,
+	WID_SCAN_CHANNEL_LIST		= 0x4084,
 
 	/* BugID_3746 WID to add IE to be added in next probe request */
-	WID_INFO_ELEMENT_PROBE	 = 0x4085,
+	WID_INFO_ELEMENT_PROBE		= 0x4085,
 	/* BugID_3746 WID to add IE to be added in next associate request */
-	WID_INFO_ELEMENT_ASSOCIATE	 = 0x4086,
-	WID_ADD_STA					 = 0X4087,
-	WID_REMOVE_STA				 = 0X4088,
-	WID_EDIT_STA					 = 0X4089,
-	WID_ADD_BEACON				= 0x408a,
+	WID_INFO_ELEMENT_ASSOCIATE	= 0x4086,
+	WID_ADD_STA			= 0X4087,
+	WID_REMOVE_STA			= 0X4088,
+	WID_EDIT_STA			= 0X4089,
+	WID_ADD_BEACON			= 0x408a,
 
 	/* BugID 5108 */
 	WID_SETUP_MULTICAST_FILTER	= 0x408b,
 
 	/* Miscellaneous WIDs */
-	WID_ALL                            = 0x7FFE,
-	WID_MAX                            = 0xFFFF
+	WID_ALL				= 0x7FFE,
+	WID_MAX				= 0xFFFF
 } WID_T;
 
 int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup);
-- 
1.9.1

