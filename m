Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38684 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753231AbcICQpw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 12:45:52 -0400
From: Colin King <colin.king@canonical.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] rtl8xxxu: fix spelling mistake "firmare" -> "firmware"
Date: Sat,  3 Sep 2016 17:43:54 +0100
Message-Id: <20160903164354.13331-1-colin.king@canonical.com> (sfid-20160903_184557_620423_50203A1C)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistakes in dev_dbg message.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 77048db..9cb1efa 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -3947,11 +3947,11 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, priv->fops->trxff_boundary);
 
 	ret = rtl8xxxu_download_firmware(priv);
-	dev_dbg(dev, "%s: download_fiwmare %i\n", __func__, ret);
+	dev_dbg(dev, "%s: download_firmware %i\n", __func__, ret);
 	if (ret)
 		goto exit;
 	ret = rtl8xxxu_start_firmware(priv);
-	dev_dbg(dev, "%s: start_fiwmare %i\n", __func__, ret);
+	dev_dbg(dev, "%s: start_firmware %i\n", __func__, ret);
 	if (ret)
 		goto exit;
 
-- 
2.9.3
