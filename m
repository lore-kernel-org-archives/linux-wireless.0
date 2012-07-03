Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40048 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933201Ab2GCROE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 13:14:04 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	qca-developer-program@qualcomm.com, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 05/20] ath9k: add BB name string for AR9550
Date: Tue,  3 Jul 2012 19:13:19 +0200
Message-Id: <1341335614-15419-6-git-send-email-juhosg@openwrt.org> (sfid-20120703_191424_585148_C9737CA8)
In-Reply-To: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
References: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 36cf591..8eb7f58 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3140,6 +3140,7 @@ static struct {
 	{ AR_SREV_VERSION_9340,		"9340" },
 	{ AR_SREV_VERSION_9485,         "9485" },
 	{ AR_SREV_VERSION_9462,         "9462" },
+	{ AR_SREV_VERSION_9550,         "9550" },
 };
 
 /* For devices with external radios */
-- 
1.7.2.1

