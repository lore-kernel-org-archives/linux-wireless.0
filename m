Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34680 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbYJ3LoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 07:44:13 -0400
Date: Thu, 30 Oct 2008 13:43:41 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
To: linville@tuxdriver.com, Larry.Finger@lwfinger.net
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 09/10] b43legacy: reindent misleading statement
In-Reply-To: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0810301341480.7072@wrl-59.cs.helsinki.fi> (sfid-20081030_124417_861425_C36A5829)
References: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-2122282121-1225367021=:7072"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-2122282121-1225367021=:7072
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 drivers/net/wireless/b43legacy/dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/dma.c b/drivers/net/wireless/b43legacy/dma.c
index fb6819e..786e028 100644
--- a/drivers/net/wireless/b43legacy/dma.c
+++ b/drivers/net/wireless/b43legacy/dma.c
@@ -919,7 +919,7 @@ struct b43legacy_dmaring *b43legacy_setup_dmaring(struct b43legacy_wldev *dev,
 			if (!ring->txhdr_cache)
 				goto err_kfree_meta;
 
-				dma_test = ssb_dma_map_single(dev->dev,
+			dma_test = ssb_dma_map_single(dev->dev,
 					ring->txhdr_cache,
 					sizeof(struct b43legacy_txhdr_fw3),
 					DMA_TO_DEVICE);
-- 
1.5.2.2

---696208474-2122282121-1225367021=:7072--
