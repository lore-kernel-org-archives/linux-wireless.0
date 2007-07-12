Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7286 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903AbXGLIKW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 04:10:22 -0400
Date: Thu, 12 Jul 2007 16:09:40 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ipw2200: Fix ipw_isr() comments error on shared IRQ
Message-ID: <20070712080940.GA28324@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Tom De Man <Tom.DeMan@DZINE.BE>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/ipw2200.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index bd0a8ff..08a33df 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -10552,7 +10552,7 @@ static irqreturn_t ipw_isr(int irq, void *data)
 	spin_lock(&priv->irq_lock);
 
 	if (!(priv->status & STATUS_INT_ENABLED)) {
-		/* Shared IRQ */
+		/* IRQ is disabled */
 		goto none;
 	}
 
-- 
1.5.2
