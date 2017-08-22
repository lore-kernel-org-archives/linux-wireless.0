Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:60046 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932427AbdHVLpY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 07:45:24 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com
Subject: [PATCH 12/30] brcmfmac: Whitespace fixes.
Date: Tue, 22 Aug 2017 12:25:32 +0100
Message-Id: <20170822112550.60311-13-ian@mnementh.co.uk> (sfid-20170822_134527_533526_656BFA6B)
In-Reply-To: <20170822112550.60311-1-ian@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 916f75e5e7a1..d5d2b2222cc1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -713,6 +713,7 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 	int err;
 
 	mypkt = brcmu_pkt_buf_get_skb(nbytes);
+
 	if (!mypkt) {
 		brcmf_err("brcmu_pkt_buf_get_skb failed: len %d\n",
 			  nbytes);
@@ -727,8 +728,8 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 		err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_2, addr, mypkt);
 
 	brcmu_pkt_buf_free_skb(mypkt);
-	return err;
 
+	return err;
 }
 
 int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
-- 
2.11.0
