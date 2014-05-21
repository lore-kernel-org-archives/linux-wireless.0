Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51423 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaEUGok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 02:44:40 -0400
Received: by mail-wg0-f44.google.com with SMTP id a1so1515905wgh.15
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 23:44:39 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] b43: fix typo in define name for 2 GHz channels (s/CHAN4G/CHAN2G/)
Date: Wed, 21 May 2014 08:44:19 +0200
Message-Id: <1400654661-3595-1-git-send-email-zajec5@gmail.com> (sfid-20140521_084444_394348_39C73BA5)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 397b7e4..88ffba2 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -182,7 +182,7 @@ static struct ieee80211_rate __b43_ratetable[] = {
 #define b43_g_ratetable		(__b43_ratetable + 0)
 #define b43_g_ratetable_size	12
 
-#define CHAN4G(_channel, _freq, _flags) {			\
+#define CHAN2G(_channel, _freq, _flags) {			\
 	.band			= IEEE80211_BAND_2GHZ,		\
 	.center_freq		= (_freq),			\
 	.hw_value		= (_channel),			\
@@ -191,22 +191,22 @@ static struct ieee80211_rate __b43_ratetable[] = {
 	.max_power		= 30,				\
 }
 static struct ieee80211_channel b43_2ghz_chantable[] = {
-	CHAN4G(1, 2412, 0),
-	CHAN4G(2, 2417, 0),
-	CHAN4G(3, 2422, 0),
-	CHAN4G(4, 2427, 0),
-	CHAN4G(5, 2432, 0),
-	CHAN4G(6, 2437, 0),
-	CHAN4G(7, 2442, 0),
-	CHAN4G(8, 2447, 0),
-	CHAN4G(9, 2452, 0),
-	CHAN4G(10, 2457, 0),
-	CHAN4G(11, 2462, 0),
-	CHAN4G(12, 2467, 0),
-	CHAN4G(13, 2472, 0),
-	CHAN4G(14, 2484, 0),
+	CHAN2G(1, 2412, 0),
+	CHAN2G(2, 2417, 0),
+	CHAN2G(3, 2422, 0),
+	CHAN2G(4, 2427, 0),
+	CHAN2G(5, 2432, 0),
+	CHAN2G(6, 2437, 0),
+	CHAN2G(7, 2442, 0),
+	CHAN2G(8, 2447, 0),
+	CHAN2G(9, 2452, 0),
+	CHAN2G(10, 2457, 0),
+	CHAN2G(11, 2462, 0),
+	CHAN2G(12, 2467, 0),
+	CHAN2G(13, 2472, 0),
+	CHAN2G(14, 2484, 0),
 };
-#undef CHAN4G
+#undef CHAN2G
 
 #define CHAN5G(_channel, _flags) {				\
 	.band			= IEEE80211_BAND_5GHZ,		\
-- 
1.8.4.5

