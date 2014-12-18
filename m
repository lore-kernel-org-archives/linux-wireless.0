Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46804 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaLRXST (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 18:18:19 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so252434wiw.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 15:18:18 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 3/3] ath9k: fix typo
Date: Fri, 19 Dec 2014 00:18:14 +0100
Message-Id: <1418944694-10614-4-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141219_001825_939122_A5B714A0)
In-Reply-To: <1418944694-10614-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1418944694-10614-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix typo

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e9bd02c..52d63de 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1106,7 +1106,7 @@ static u8 ath_get_rate_txpower(struct ath_softc *sc, struct ath_buf *bf,
 		return MAX_RATE_POWER;
 
 	if (!AR_SREV_9300_20_OR_LATER(ah)) {
-		/* ar9002 is not sipported for the moment */
+		/* ar9002 does not support TPC for the moment */
 		return MAX_RATE_POWER;
 	}
 
-- 
2.1.0

