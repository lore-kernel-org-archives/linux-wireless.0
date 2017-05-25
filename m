Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:36175 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161867AbdEYALv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 20:11:51 -0400
Received: by mail-pf0-f181.google.com with SMTP id m17so150176720pfg.3
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 17:11:51 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 14/14] mwifiex: pcie: fix whitespace
Date: Wed, 24 May 2017 17:11:19 -0700
Message-Id: <20170525001119.64791-14-briannorris@chromium.org> (sfid-20170525_021433_861582_80E14A32)
In-Reply-To: <20170525001119.64791-1-briannorris@chromium.org>
References: <20170525001119.64791-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This keeps annoying me.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index c86119b05f52..4f1d946ea460 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3211,7 +3211,7 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 	} else {
 		mwifiex_dbg(adapter, INFO,
 			    "%s(): calling free_irq()\n", __func__);
-	       free_irq(card->dev->irq, &card->share_irq_ctx);
+		free_irq(card->dev->irq, &card->share_irq_ctx);
 
 		if (card->msi_enable)
 			pci_disable_msi(pdev);
-- 
2.13.0.219.gdb65acc882-goog
