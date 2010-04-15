Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32955 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400Ab0DOVjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 75/97] ath9k_hw: add the AR9300 SREV hw name print
Date: Thu, 15 Apr 2010 17:39:20 -0400
Message-Id: <1271367582-992-76-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9e4288a..de7ee90 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2690,6 +2690,7 @@ static struct {
 	{ AR_SREV_VERSION_9285,		"9285" },
 	{ AR_SREV_VERSION_9287,         "9287" },
 	{ AR_SREV_VERSION_9271,         "9271" },
+	{ AR_SREV_VERSION_9300,         "9300" },
 };
 
 /* For devices with external radios */
-- 
1.6.3.3

