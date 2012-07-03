Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40019 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab2GCROB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 13:14:01 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	qca-developer-program@qualcomm.com, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 02/20] ath9k: define MAC version for AR9550
Date: Tue,  3 Jul 2012 19:13:16 +0200
Message-Id: <1341335614-15419-3-git-send-email-juhosg@openwrt.org> (sfid-20120703_191406_440986_A792C50D)
In-Reply-To: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
References: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/reg.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index dd9c726..22d2413 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -798,6 +798,7 @@
 #define AR_SREV_REVISION_9580_10	4 /* AR9580 1.0 */
 #define AR_SREV_VERSION_9462		0x280
 #define AR_SREV_REVISION_9462_20	2
+#define AR_SREV_VERSION_9550		0x400
 
 #define AR_SREV_5416(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) || \
@@ -905,6 +906,9 @@
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9462) && \
 	((_ah)->hw_version.macRev >= AR_SREV_REVISION_9462_20))
 
+#define AR_SREV_9550(_ah) \
+	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9550))
+
 #define AR_SREV_9580(_ah) \
 	(((_ah)->hw_version.macVersion == AR_SREV_VERSION_9580) && \
 	((_ah)->hw_version.macRev >= AR_SREV_REVISION_9580_10))
-- 
1.7.2.1

