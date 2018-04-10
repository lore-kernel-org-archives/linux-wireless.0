Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:33520 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752057AbeDJCwl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 22:52:41 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 6/9] rtlwifi: btcoex: remove comments that are not meaningful
Date: Tue, 10 Apr 2018 10:52:23 +0800
Message-ID: <20180410025226.5236-7-pkshih@realtek.com> (sfid-20180410_045246_484020_AE4FE997)
In-Reply-To: <20180410025226.5236-1-pkshih@realtek.com>
References: <20180410025226.5236-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The comments aren't meaningful and the use of '***...***' isn't upstream
style, so remove them. This patch doesn't change any code.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 22 +-------------------
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 24 +---------------------
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 23 ++-------------------
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 22 +-------------------
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 23 +--------------------
 5 files changed, 6 insertions(+), 108 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index 8fce371749d3..959af05117d7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -22,23 +22,9 @@
  * Larry Finger <Larry.Finger@lwfinger.net>
  *
  *****************************************************************************/
-/**************************************************************
- * Description:
- *
- * This file is for RTL8192E Co-exist mechanism
- *
- * History
- * 2012/11/15 Cosa first check in.
- *
- **************************************************************/
 
-/**************************************************************
- *   include files
- **************************************************************/
 #include "halbt_precomp.h"
-/**************************************************************
- *   Global variables, these are static variables
- **************************************************************/
+
 static struct coex_dm_8192e_2ant glcoex_dm_8192e_2ant;
 static struct coex_dm_8192e_2ant *coex_dm = &glcoex_dm_8192e_2ant;
 static struct coex_sta_8192e_2ant glcoex_sta_8192e_2ant;
@@ -53,12 +39,6 @@ static const char *const glbt_info_src_8192e_2ant[] = {
 static u32 glcoex_ver_date_8192e_2ant = 20130902;
 static u32 glcoex_ver_8192e_2ant = 0x34;
 
-/**************************************************************
- *   local function proto type if needed
- **************************************************************/
-/**************************************************************
- *   local function start with btc8192e2ant_
- **************************************************************/
 static u8 btc8192e2ant_bt_rssi_state(struct btc_coexist *btcoexist,
 				     u8 level_num, u8 rssi_thresh,
 				     u8 rssi_thresh1)
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 59553db020ef..e97e907e66cd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -23,23 +23,8 @@
  *
  *****************************************************************************/
 
-/***************************************************************
- * Description:
- *
- * This file is for RTL8723B Co-exist mechanism
- *
- * History
- * 2012/11/15 Cosa first check in.
- *
- ***************************************************************/
-
-/***************************************************************
- * include files
- ***************************************************************/
 #include "halbt_precomp.h"
-/***************************************************************
- * Global variables, these are static variables
- ***************************************************************/
+
 static struct coex_dm_8723b_1ant glcoex_dm_8723b_1ant;
 static struct coex_dm_8723b_1ant *coex_dm = &glcoex_dm_8723b_1ant;
 static struct coex_sta_8723b_1ant glcoex_sta_8723b_1ant;
@@ -54,13 +39,6 @@ static const char *const glbt_info_src_8723b_1ant[] = {
 static u32 glcoex_ver_date_8723b_1ant = 20130918;
 static u32 glcoex_ver_8723b_1ant = 0x47;
 
-/***************************************************************
- * local function proto type if needed
- ***************************************************************/
-/***************************************************************
- * local function start with halbtc8723b1ant_
- ***************************************************************/
-
 static void halbtc8723b1ant_updatera_mask(struct btc_coexist *btcoexist,
 					  bool force_exec, u32 dis_rate_mask)
 {
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 73ec31972944..e9a7f303cdda 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -22,22 +22,9 @@
  * Larry Finger <Larry.Finger@lwfinger.net>
  *
  *****************************************************************************/
-/***************************************************************
- * Description:
- *
- * This file is for RTL8723B Co-exist mechanism
- *
- * History
- * 2012/11/15 Cosa first check in.
- *
- **************************************************************/
-/**************************************************************
- * include files
- **************************************************************/
+
 #include "halbt_precomp.h"
-/**************************************************************
- * Global variables, these are static variables
- **************************************************************/
+
 static struct coex_dm_8723b_2ant glcoex_dm_8723b_2ant;
 static struct coex_dm_8723b_2ant *coex_dm = &glcoex_dm_8723b_2ant;
 static struct coex_sta_8723b_2ant glcoex_sta_8723b_2ant;
@@ -52,12 +39,6 @@ static const char *const glbt_info_src_8723b_2ant[] = {
 static u32 glcoex_ver_date_8723b_2ant = 20131113;
 static u32 glcoex_ver_8723b_2ant = 0x3f;
 
-/**************************************************************
- * local function proto type if needed
- **************************************************************/
-/**************************************************************
- * local function start with btc8723b2ant_
- **************************************************************/
 static u8 btc8723b2ant_bt_rssi_state(struct btc_coexist *btcoexist,
 				     u8 level_num, u8 rssi_thresh,
 				     u8 rssi_thresh1)
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 202597cf8915..39dc5966700b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -23,23 +23,8 @@
  *
  *****************************************************************************/
 
-/**************************************************************
- * Description:
- *
- * This file is for RTL8821A Co-exist mechanism
- *
- * History
- * 2012/11/15 Cosa first check in.
- *
- **************************************************************/
-
-/**************************************************************
- * include files
- **************************************************************/
 #include "halbt_precomp.h"
-/**************************************************************
- * Global variables, these are static variables
- **************************************************************/
+
 static struct coex_dm_8821a_1ant glcoex_dm_8821a_1ant;
 static struct coex_dm_8821a_1ant *coex_dm = &glcoex_dm_8821a_1ant;
 static struct coex_sta_8821a_1ant glcoex_sta_8821a_1ant;
@@ -56,11 +41,6 @@ static const char *const glbt_info_src_8821a_1ant[] = {
 static u32 glcoex_ver_date_8821a_1ant = 20130816;
 static u32 glcoex_ver_8821a_1ant = 0x41;
 
-/**************************************************************
- * local function proto type if needed
- *
- * local function start with btc8821a1ant_
- **************************************************************/
 static u8 btc8821a1ant_bt_rssi_state(struct btc_coexist *btcoexist,
 				     u8 level_num, u8 rssi_thresh,
 				     u8 rssi_thresh1)
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 2202d5e18977..264796616d8a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -23,24 +23,8 @@
  *
  *****************************************************************************/
 
-/************************************************************
- * Description:
- *
- * This file is for RTL8821A Co-exist mechanism
- *
- * History
- * 2012/08/22 Cosa first check in.
- * 2012/11/14 Cosa Revise for 8821A 2Ant out sourcing.
- *
- ************************************************************/
-
-/************************************************************
- * include files
- ************************************************************/
 #include "halbt_precomp.h"
-/************************************************************
- * Global variables, these are static variables
- ************************************************************/
+
 static struct coex_dm_8821a_2ant glcoex_dm_8821a_2ant;
 static struct coex_dm_8821a_2ant *coex_dm = &glcoex_dm_8821a_2ant;
 static struct coex_sta_8821a_2ant glcoex_sta_8821a_2ant;
@@ -55,11 +39,6 @@ static const char *const glbt_info_src_8821a_2ant[] = {
 static u32 glcoex_ver_date_8821a_2ant = 20130618;
 static u32 glcoex_ver_8821a_2ant = 0x5050;
 
-/************************************************************
- * local function proto type if needed
- *
- * local function start with btc8821a2ant_
- ************************************************************/
 static u8 btc8821a2ant_bt_rssi_state(struct btc_coexist *btcoexist,
 				     u8 level_num, u8 rssi_thresh,
 				     u8 rssi_thresh1)
-- 
2.15.1
