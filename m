Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55683 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZJZOi5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 10:38:57 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/4] ath9k_hw: add AR9271 single chip name mapping
Date: Mon, 26 Oct 2009 10:39:00 -0400
Message-Id: <1256567941-26859-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1256567941-26859-1-git-send-email-lrodriguez@atheros.com>
References: <1256567941-26859-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f65b591..50be381 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3941,7 +3941,8 @@ static struct {
 	/* Single-chip solutions */
 	{ AR_SREV_VERSION_9280,		"9280" },
 	{ AR_SREV_VERSION_9285,		"9285" },
-	{ AR_SREV_VERSION_9287,         "9287" }
+	{ AR_SREV_VERSION_9287,         "9287" },
+	{ AR_SREV_VERSION_9271,         "9271" },
 };
 
 /* For devices with external radios */
-- 
1.6.0.4

