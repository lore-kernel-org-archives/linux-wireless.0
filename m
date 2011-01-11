Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52463 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab1AKTt3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 14:49:29 -0500
Received: by wwi17 with SMTP id 17so3082118wwi.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 11:49:28 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] wl12xx: Add channel 14 to list of supported 2ghz channels
Date: Tue, 11 Jan 2011 21:49:17 +0200
Message-Id: <1294775357-10821-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
drivers/net/wireless/wl12xx/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 062247e..a7afdca 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2305,6 +2305,7 @@ static struct ieee80211_channel wl1271_channels[] = {
 	{ .hw_value = 11, .center_freq = 2462, .max_power = 25 },
 	{ .hw_value = 12, .center_freq = 2467, .max_power = 25 },
 	{ .hw_value = 13, .center_freq = 2472, .max_power = 25 },
+	{ .hw_value = 14, .center_freq = 2484, .max_power = 25 },
 };
 
 /* mapping to indexes for wl1271_rates */
-- 
1.7.1

