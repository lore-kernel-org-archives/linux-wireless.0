Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fep02.xtra.co.nz ([210.54.141.244]:16700 "EHLO fep02.xtra.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab0CVMOQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 08:14:16 -0400
Date: Tue, 23 Mar 2010 00:52:44 +1300
From: Daniel Ngu <daniel.dy.ngu@gmail.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net/wireless/b43/main.c:4351: Fixed coding style
Message-ID: <20100322115244.GA10368@zooey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Daniel Ngu <daniel.dy.ngu@gmail.com>
---
 drivers/net/wireless/b43/main.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 1521b1e..14cf3bd 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4348,11 +4348,10 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	b43_set_phytxctl_defaults(dev);
 
 	/* Minimum Contention Window */
-	if (phy->type == B43_PHYTYPE_B) {
+	if (phy->type == B43_PHYTYPE_B)
 		b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_MINCONT, 0x1F);
-	} else {
+	else
 		b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_MINCONT, 0xF);
-	}
 	/* Maximum Contention Window */
 	b43_shm_write16(dev, B43_SHM_SCRATCH, B43_SHM_SC_MAXCONT, 0x3FF);
 
-- 
1.5.6.5

