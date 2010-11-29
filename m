Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:56908 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab0K2KGR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 05:06:17 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oATA6Fd0028861
	for <linux-wireless@vger.kernel.org>; Mon, 29 Nov 2010 12:06:15 +0200
From: juuso.oikarinen@nokia.com
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: Remove 11j channels from the supported channels list.
Date: Mon, 29 Nov 2010 12:05:53 +0200
Message-Id: <1291025153-17570-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Because we don't support them at this stage.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/main.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7fecefe..dc3a093 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2374,14 +2374,6 @@ static struct ieee80211_rate wl1271_rates_5ghz[] = {
 
 /* 5 GHz band channels for WL1273 */
 static struct ieee80211_channel wl1271_channels_5ghz[] = {
-	{ .hw_value = 183, .center_freq = 4915},
-	{ .hw_value = 184, .center_freq = 4920},
-	{ .hw_value = 185, .center_freq = 4925},
-	{ .hw_value = 187, .center_freq = 4935},
-	{ .hw_value = 188, .center_freq = 4940},
-	{ .hw_value = 189, .center_freq = 4945},
-	{ .hw_value = 192, .center_freq = 4960},
-	{ .hw_value = 196, .center_freq = 4980},
 	{ .hw_value = 7, .center_freq = 5035},
 	{ .hw_value = 8, .center_freq = 5040},
 	{ .hw_value = 9, .center_freq = 5045},
-- 
1.7.1

