Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55700 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1D0EH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 00:07:58 -0400
Received: by iyb14 with SMTP id 14so1056960iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 21:07:57 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19895.38710.490485.761234@gargle.gargle.HOWL> (sfid-20110427_060804_707346_321631C9)
Date: Wed, 27 Apr 2011 09:40:30 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] iw: Clarify bitrate mask documentation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 bitrate.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/bitrate.c b/bitrate.c
index 0012514..cefd150 100644
--- a/bitrate.c
+++ b/bitrate.c
@@ -137,4 +137,6 @@ static int handle_bitrates(struct nl80211_state *state,
 #endif
 
 COMMAND(set, bitrates, DESCR, NL80211_CMD_SET_TX_BITRATE_MASK, 0, CIB_NETDEV,
-	handle_bitrates, "Sets up the specified rate masks.");
+	handle_bitrates,
+	"Sets up the specified rate masks.\n"
+	"Not passing any arguments would clear the existing mask (if any).");
-- 
1.7.4.4

