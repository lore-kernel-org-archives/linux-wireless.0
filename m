Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40615 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933351Ab2GCRPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 13:15:06 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	qca-developer-program@qualcomm.com, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 20/20] ath9k: enable support for AR9550
Date: Tue,  3 Jul 2012 19:13:34 +0200
Message-Id: <1341335614-15419-21-git-send-email-juhosg@openwrt.org> (sfid-20120703_191514_709428_B33CFEC2)
In-Reply-To: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
References: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 991b2ef..5a2b9e3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -649,6 +649,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	case AR_SREV_VERSION_9485:
 	case AR_SREV_VERSION_9340:
 	case AR_SREV_VERSION_9462:
+	case AR_SREV_VERSION_9550:
 		break;
 	default:
 		ath_err(common,
@@ -730,6 +731,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	case AR9300_DEVID_AR9485_PCIE:
 	case AR9300_DEVID_AR9330:
 	case AR9300_DEVID_AR9340:
+	case AR9300_DEVID_QCA955X:
 	case AR9300_DEVID_AR9580:
 	case AR9300_DEVID_AR9462:
 		break;
-- 
1.7.2.1

