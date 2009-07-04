Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3085 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbZGDRAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 13:00:52 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/5] ath: remove unnecessary return in ath_regd_get_band_ctl
Date: Sat,  4 Jul 2009 12:59:53 -0400
Message-Id: <1246726795-3934-4-git-send-email-me@bobcopeland.com>
In-Reply-To: <1246726795-3934-1-git-send-email-me@bobcopeland.com>
References: <1246726795-3934-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'default' case already returns NO_CTL

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/regd.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index eef370b..f37c832 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -569,7 +569,5 @@ u32 ath_regd_get_band_ctl(struct ath_regulatory *reg,
 	default:
 		return NO_CTL;
 	}
-
-	return NO_CTL;
 }
 EXPORT_SYMBOL(ath_regd_get_band_ctl);
-- 
1.6.2.5


