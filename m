Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3359 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbYJ2MbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 08:31:15 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, mickflemm@gmail.com, jirislaby@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath5k: correct misspelling in debug help
Date: Wed, 29 Oct 2008 08:30:53 -0400
Message-Id: <1225283457-24417-1-git-send-email-me@bobcopeland.com> (sfid-20081029_133121_011692_FCB8205F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change "mamagement" to "management"

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
index 8f92d67..19980cb 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -339,7 +339,7 @@ static struct {
 	{ ATH5K_DEBUG_BEACON,	"beacon",	"beacon handling" },
 	{ ATH5K_DEBUG_CALIBRATE, "calib",	"periodic calibration" },
 	{ ATH5K_DEBUG_TXPOWER,	"txpower",	"transmit power setting" },
-	{ ATH5K_DEBUG_LED,	"led",		"LED mamagement" },
+	{ ATH5K_DEBUG_LED,	"led",		"LED management" },
 	{ ATH5K_DEBUG_DUMP_RX,	"dumprx",	"print received skb content" },
 	{ ATH5K_DEBUG_DUMP_TX,	"dumptx",	"print transmit skb content" },
 	{ ATH5K_DEBUG_DUMPBANDS, "dumpbands",	"dump bands" },
-- 
1.5.4.2.182.gb3092


