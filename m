Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51659 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab0LGTPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 14:15:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: remove MODULE_VERSION
Date: Tue,  7 Dec 2010 14:13:49 -0500
Message-Id: <1291749229-25753-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <20101203041109.GE2988@makis.mantri>
References: <20101203041109.GE2988@makis.mantri>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since this is updated manually and sporadically, it is fairly useless
anyway.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 380ff2f..15d6b6c 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -76,7 +76,6 @@ MODULE_AUTHOR("Nick Kossifidis");
 MODULE_DESCRIPTION("Support for 5xxx series of Atheros 802.11 wireless LAN cards.");
 MODULE_SUPPORTED_DEVICE("Atheros 5xxx WLAN cards");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_VERSION("0.6.0 (EXPERIMENTAL)");
 
 static int ath5k_init(struct ieee80211_hw *hw);
 static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
-- 
1.7.3.2

