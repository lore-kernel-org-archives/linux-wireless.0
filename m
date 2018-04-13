Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:42543 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752669AbeDMGQj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 02:16:39 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v4 7/9] rtlwifi: btcoex: Add modifier const to version related variables
Date: Fri, 13 Apr 2018 14:16:11 +0800
Message-ID: <20180413061613.8569-8-pkshih@realtek.com> (sfid-20180413_081652_374212_DE873DE5)
In-Reply-To: <20180413061613.8569-1-pkshih@realtek.com>
References: <20180413061613.8569-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The variables declared as 'static' look a little weird. Since they are
version of btcoex and only used to display in debug message, this patch
changes them to 'static const' to make it clear.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c | 4 ++--
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index 959af05117d7..a4704b2fbeb9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -36,8 +36,8 @@ static const char *const glbt_info_src_8192e_2ant[] = {
 	"BT Info[bt auto report]",
 };
 
-static u32 glcoex_ver_date_8192e_2ant = 20130902;
-static u32 glcoex_ver_8192e_2ant = 0x34;
+static const u32 glcoex_ver_date_8192e_2ant = 20130902;
+static const u32 glcoex_ver_8192e_2ant = 0x34;
 
 static u8 btc8192e2ant_bt_rssi_state(struct btc_coexist *btcoexist,
 				     u8 level_num, u8 rssi_thresh,
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index e97e907e66cd..31b716fa2524 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -36,8 +36,8 @@ static const char *const glbt_info_src_8723b_1ant[] = {
 	"BT Info[bt auto report]",
 };
 
-static u32 glcoex_ver_date_8723b_1ant = 20130918;
-static u32 glcoex_ver_8723b_1ant = 0x47;
+static const u32 glcoex_ver_date_8723b_1ant = 20130918;
+static const u32 glcoex_ver_8723b_1ant = 0x47;
 
 static void halbtc8723b1ant_updatera_mask(struct btc_coexist *btcoexist,
 					  bool force_exec, u32 dis_rate_mask)
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index e9a7f303cdda..8c1cec306bf1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -36,8 +36,8 @@ static const char *const glbt_info_src_8723b_2ant[] = {
 	"BT Info[bt auto report]",
 };
 
-static u32 glcoex_ver_date_8723b_2ant = 20131113;
-static u32 glcoex_ver_8723b_2ant = 0x3f;
+static const u32 glcoex_ver_date_8723b_2ant = 20131113;
+static const u32 glcoex_ver_8723b_2ant = 0x3f;
 
 static u8 btc8723b2ant_bt_rssi_state(struct btc_coexist *btcoexist,
 				     u8 level_num, u8 rssi_thresh,
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 39dc5966700b..cb34a33ae99a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -38,8 +38,8 @@ static const char *const glbt_info_src_8821a_1ant[] = {
 	  "BT Info[bt auto report]",
 };
 
-static u32 glcoex_ver_date_8821a_1ant = 20130816;
-static u32 glcoex_ver_8821a_1ant = 0x41;
+static const u32 glcoex_ver_date_8821a_1ant = 20130816;
+static const u32 glcoex_ver_8821a_1ant = 0x41;
 
 static u8 btc8821a1ant_bt_rssi_state(struct btc_coexist *btcoexist,
 				     u8 level_num, u8 rssi_thresh,
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 264796616d8a..14510d514e2f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -36,8 +36,8 @@ static const char *const glbt_info_src_8821a_2ant[] = {
 	"BT Info[bt auto report]",
 };
 
-static u32 glcoex_ver_date_8821a_2ant = 20130618;
-static u32 glcoex_ver_8821a_2ant = 0x5050;
+static const u32 glcoex_ver_date_8821a_2ant = 20130618;
+static const u32 glcoex_ver_8821a_2ant = 0x5050;
 
 static u8 btc8821a2ant_bt_rssi_state(struct btc_coexist *btcoexist,
 				     u8 level_num, u8 rssi_thresh,
-- 
2.15.1
