Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41820 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab1FUJZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:25:00 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 32/32] ath9k: enable support for AR9330
Date: Tue, 21 Jun 2011 11:23:52 +0200
Message-Id: <1308648232-9906-33-git-send-email-juhosg@openwrt.org> (sfid-20110621_112532_828033_309D9082)
In-Reply-To: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
References: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 839ba64..07827b5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -644,6 +644,7 @@ int ath9k_hw_init(struct ath_hw *ah)
 	case AR2427_DEVID_PCIE:
 	case AR9300_DEVID_PCIE:
 	case AR9300_DEVID_AR9485_PCIE:
+	case AR9300_DEVID_AR9330:
 	case AR9300_DEVID_AR9340:
 		break;
 	default:
-- 
1.7.2.1

