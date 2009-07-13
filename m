Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51794 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbZGMHJV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 03:09:21 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 00:09:21 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 3/3] ath9k: Remove pointless ath9k_ps_restore() in ath_detach()
Date: Mon, 13 Jul 2009 12:32:07 +0530
Message-ID: <1247468527-5097-3-git-send-email-vasanth@atheros.com>
In-Reply-To: <1247468527-5097-2-git-send-email-vasanth@atheros.com>
References: <1247468527-5097-1-git-send-email-vasanth@atheros.com>
 <1247468527-5097-2-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 961b0ce..16e5f6e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1284,7 +1284,6 @@ void ath_detach(struct ath_softc *sc)
 
 	ath9k_hw_detach(sc->sc_ah);
 	ath9k_exit_debug(sc);
-	ath9k_ps_restore(sc);
 }
 
 static int ath9k_reg_notifier(struct wiphy *wiphy,
-- 
1.5.5.1

