Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:43220 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab1HWA0h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 20:26:37 -0400
From: Bing Zhao <bzhao@marvell.com>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] libertas: update readme file
Date: Mon, 22 Aug 2011 17:26:37 -0700
Message-Id: <1314059197-8377-1-git-send-email-bzhao@marvell.com> (sfid-20110823_022640_877552_ADB855B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Since all wext specific code is removed, currently there is no
way to configure deep sleep mode. This patch removes deep sleep
configuration information in readme file.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/libertas/README |   25 -------------------------
 1 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/libertas/README b/drivers/net/wireless/libertas/README
index 1453eec..91f2ca9 100644
--- a/drivers/net/wireless/libertas/README
+++ b/drivers/net/wireless/libertas/README
@@ -238,28 +238,3 @@ hostsleep
 		echo "1" > hostsleep : enable host sleep.
 		echo "0" > hostsleep : disable host sleep
 
-========================
-IWCONFIG COMMANDS
-========================
-power period
-
-	This command is used to configure the station in deep sleep mode /
-	auto deep sleep mode.
-
-	The timer is implemented to monitor the activities (command, event,
-	etc.). When an activity is detected station will exit from deep
-	sleep mode automatically and restart the timer. At timer expiry
-	(no activity for defined time period) the deep sleep mode is entered
-	automatically.
-
-	Note: this command is for SDIO interface only.
-
-	Usage:
-	To enable deep sleep mode do:
-		iwconfig wlan0 power period 0
-	To enable auto deep sleep mode with idle time period 5 seconds do:
-		iwconfig wlan0 power period 5
-	To disable deep sleep/auto deep sleep mode do:
-		iwconfig wlan0 power period -1
-
-==============================================================================
-- 
1.5.3.4

