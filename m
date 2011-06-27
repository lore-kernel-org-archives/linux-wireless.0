Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49766 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab1F0TGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 15:06:41 -0400
Received: by wwe5 with SMTP id 5so5058241wwe.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 12:06:40 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/2] wl12xx: initialize max_power levels for 11a channels
Date: Mon, 27 Jun 2011 22:06:33 +0300
Message-Id: <1309201594-12582-1-git-send-email-arik@wizery.com> (sfid-20110627_210655_474822_0A2E20E0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the maximum FW supported power levels for 11a channels.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   68 ++++++++++++++++++------------------
 1 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index fb0f764..effde53 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3686,40 +3686,40 @@ static struct ieee80211_rate wl1271_rates_5ghz[] = {
 
 /* 5 GHz band channels for WL1273 */
 static struct ieee80211_channel wl1271_channels_5ghz[] = {
-	{ .hw_value = 7, .center_freq = 5035},
-	{ .hw_value = 8, .center_freq = 5040},
-	{ .hw_value = 9, .center_freq = 5045},
-	{ .hw_value = 11, .center_freq = 5055},
-	{ .hw_value = 12, .center_freq = 5060},
-	{ .hw_value = 16, .center_freq = 5080},
-	{ .hw_value = 34, .center_freq = 5170},
-	{ .hw_value = 36, .center_freq = 5180},
-	{ .hw_value = 38, .center_freq = 5190},
-	{ .hw_value = 40, .center_freq = 5200},
-	{ .hw_value = 42, .center_freq = 5210},
-	{ .hw_value = 44, .center_freq = 5220},
-	{ .hw_value = 46, .center_freq = 5230},
-	{ .hw_value = 48, .center_freq = 5240},
-	{ .hw_value = 52, .center_freq = 5260},
-	{ .hw_value = 56, .center_freq = 5280},
-	{ .hw_value = 60, .center_freq = 5300},
-	{ .hw_value = 64, .center_freq = 5320},
-	{ .hw_value = 100, .center_freq = 5500},
-	{ .hw_value = 104, .center_freq = 5520},
-	{ .hw_value = 108, .center_freq = 5540},
-	{ .hw_value = 112, .center_freq = 5560},
-	{ .hw_value = 116, .center_freq = 5580},
-	{ .hw_value = 120, .center_freq = 5600},
-	{ .hw_value = 124, .center_freq = 5620},
-	{ .hw_value = 128, .center_freq = 5640},
-	{ .hw_value = 132, .center_freq = 5660},
-	{ .hw_value = 136, .center_freq = 5680},
-	{ .hw_value = 140, .center_freq = 5700},
-	{ .hw_value = 149, .center_freq = 5745},
-	{ .hw_value = 153, .center_freq = 5765},
-	{ .hw_value = 157, .center_freq = 5785},
-	{ .hw_value = 161, .center_freq = 5805},
-	{ .hw_value = 165, .center_freq = 5825},
+	{ .hw_value = 7, .center_freq = 5035, .max_power = 25 },
+	{ .hw_value = 8, .center_freq = 5040, .max_power = 25 },
+	{ .hw_value = 9, .center_freq = 5045, .max_power = 25 },
+	{ .hw_value = 11, .center_freq = 5055, .max_power = 25 },
+	{ .hw_value = 12, .center_freq = 5060, .max_power = 25 },
+	{ .hw_value = 16, .center_freq = 5080, .max_power = 25 },
+	{ .hw_value = 34, .center_freq = 5170, .max_power = 25 },
+	{ .hw_value = 36, .center_freq = 5180, .max_power = 25 },
+	{ .hw_value = 38, .center_freq = 5190, .max_power = 25 },
+	{ .hw_value = 40, .center_freq = 5200, .max_power = 25 },
+	{ .hw_value = 42, .center_freq = 5210, .max_power = 25 },
+	{ .hw_value = 44, .center_freq = 5220, .max_power = 25 },
+	{ .hw_value = 46, .center_freq = 5230, .max_power = 25 },
+	{ .hw_value = 48, .center_freq = 5240, .max_power = 25 },
+	{ .hw_value = 52, .center_freq = 5260, .max_power = 25 },
+	{ .hw_value = 56, .center_freq = 5280, .max_power = 25 },
+	{ .hw_value = 60, .center_freq = 5300, .max_power = 25 },
+	{ .hw_value = 64, .center_freq = 5320, .max_power = 25 },
+	{ .hw_value = 100, .center_freq = 5500, .max_power = 25 },
+	{ .hw_value = 104, .center_freq = 5520, .max_power = 25 },
+	{ .hw_value = 108, .center_freq = 5540, .max_power = 25 },
+	{ .hw_value = 112, .center_freq = 5560, .max_power = 25 },
+	{ .hw_value = 116, .center_freq = 5580, .max_power = 25 },
+	{ .hw_value = 120, .center_freq = 5600, .max_power = 25 },
+	{ .hw_value = 124, .center_freq = 5620, .max_power = 25 },
+	{ .hw_value = 128, .center_freq = 5640, .max_power = 25 },
+	{ .hw_value = 132, .center_freq = 5660, .max_power = 25 },
+	{ .hw_value = 136, .center_freq = 5680, .max_power = 25 },
+	{ .hw_value = 140, .center_freq = 5700, .max_power = 25 },
+	{ .hw_value = 149, .center_freq = 5745, .max_power = 25 },
+	{ .hw_value = 153, .center_freq = 5765, .max_power = 25 },
+	{ .hw_value = 157, .center_freq = 5785, .max_power = 25 },
+	{ .hw_value = 161, .center_freq = 5805, .max_power = 25 },
+	{ .hw_value = 165, .center_freq = 5825, .max_power = 25 },
 };
 
 /* mapping to indexes for wl1271_rates_5ghz */
-- 
1.7.4.1

