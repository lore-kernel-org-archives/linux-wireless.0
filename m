Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39705 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbZJ0Q7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 12:59:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/5] ath9k_hw: add AR9271 single chip name mapping
Date: Tue, 27 Oct 2009 12:59:35 -0400
Message-Id: <1256662777-20469-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1256662777-20469-1-git-send-email-lrodriguez@atheros.com>
References: <1256662777-20469-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index dedffb8..bb540bf 100644
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

