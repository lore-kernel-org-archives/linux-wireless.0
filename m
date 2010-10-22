Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62591 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab0JVPne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 11:43:34 -0400
Received: by eye27 with SMTP id 27so1166345eye.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 08:43:32 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/5] b43: N-PHY: fix infinite-loop-typo
Date: Fri, 22 Oct 2010 17:43:45 +0200
Message-Id: <1287762229-16516-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index dfec549..e0f2d12 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2964,7 +2964,7 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
 					(2 - i));
 		}
 
-		for (j = 0; i < 4; j++) {
+		for (j = 0; j < 4; j++) {
 			if (j < 3) {
 				cur_lna = lna[j];
 				cur_hpf1 = hpf1[j];
-- 
1.7.1

