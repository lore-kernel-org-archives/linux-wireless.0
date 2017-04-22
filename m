Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43557 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753728AbdDVNV4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Apr 2017 09:21:56 -0400
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Tobias Klauser <tklauser@distanz.ch>,
        Jarod Wilson <jarod@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] orinoco:  fix spelling mistake: "Registerred" -> "Registered"
Date: Sat, 22 Apr 2017 14:21:49 +0100
Message-Id: <20170422132149.10901-1-colin.king@canonical.com> (sfid-20170422_152216_952794_ECC11C1C)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in dbg_dbg message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intersil/orinoco/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/orinoco/main.c b/drivers/net/wireless/intersil/orinoco/main.c
index 28cf97489001..d9128bb25e85 100644
--- a/drivers/net/wireless/intersil/orinoco/main.c
+++ b/drivers/net/wireless/intersil/orinoco/main.c
@@ -2283,7 +2283,7 @@ int orinoco_if_add(struct orinoco_private *priv,
 	priv->ndev = dev;
 
 	/* Report what we've done */
-	dev_dbg(priv->dev, "Registerred interface %s.\n", dev->name);
+	dev_dbg(priv->dev, "Registered interface %s.\n", dev->name);
 
 	return 0;
 
-- 
2.11.0
