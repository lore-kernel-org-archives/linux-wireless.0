Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63652 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1LUXGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 18:06:13 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so7959769eek.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 15:06:12 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/4] b43: N-PHY: fix typo in TX power fix
Date: Thu, 22 Dec 2011 00:47:19 +0100
Message-Id: <1324511239-3536-4-git-send-email-zajec5@gmail.com> (sfid-20111222_000619_218140_ABEA9E61)
In-Reply-To: <1324511239-3536-1-git-send-email-zajec5@gmail.com>
References: <1324511239-3536-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index b8525cc..aadfed0 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2218,7 +2218,7 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 		}
 	}
 	if (dev->phy.rev < 7 &&
-	    (txpi[0] < 40 || txpi[0] > 100 || txpi[1] < 40 || txpi[1] > 10))
+	    (txpi[0] < 40 || txpi[0] > 100 || txpi[1] < 40 || txpi[1] > 100))
 		txpi[0] = txpi[1] = 91;
 
 	/*
-- 
1.7.3.4

