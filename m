Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45026 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751463AbcIISB1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 14:01:27 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Colin Ian King <colin.king@canonical.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 2/2] rtl8xxxu: fix spelling mistake "firmare" -> "firmware"
Date: Fri,  9 Sep 2016 14:01:25 -0400
Message-Id: <1473444085-6363-3-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160909_200130_459641_FFF40622)
In-Reply-To: <1473444085-6363-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1473444085-6363-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistakes in dev_dbg message.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index d2611a4..ca92022 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -3921,11 +3921,11 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
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
2.7.4
