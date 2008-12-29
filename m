Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:41556 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbYL2UPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 15:15:06 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: lrodriguez@atheros.com
Cc: ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] ath9k: use signed format to print HAL status
Date: Mon, 29 Dec 2008 21:07:42 +0100
Message-Id: <1230581262-14932-1-git-send-email-juhosg@openwrt.org> (sfid-20081229_211521_721883_91ECD437)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath9k/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 70affb7..226ff7e 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1354,7 +1354,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	ah = ath9k_hw_attach(devid, sc, sc->mem, &status);
 	if (ah == NULL) {
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"Unable to attach hardware; HAL status %u\n", status);
+			"Unable to attach hardware; HAL status %d\n", status);
 		error = -ENXIO;
 		goto bad;
 	}
-- 
1.5.3.2

