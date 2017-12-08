Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:43787 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753055AbdLHMKp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 07:10:45 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 02/10] brcmfmac: whitespace fixes in brcmf_sdiod_send_buf()
Date: Fri,  8 Dec 2017 13:10:27 +0100
Message-Id: <1512735035-342-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171208_131058_606433_558BC985)
In-Reply-To: <1512735035-342-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1512735035-342-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
[arend: mention function in patch subject]
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index d9ecc69..bff4610 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -714,6 +714,7 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 	int err;
 
 	mypkt = brcmu_pkt_buf_get_skb(nbytes);
+
 	if (!mypkt) {
 		brcmf_err("brcmu_pkt_buf_get_skb failed: len %d\n",
 			  nbytes);
@@ -728,8 +729,8 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 		err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_2, addr, mypkt);
 
 	brcmu_pkt_buf_free_skb(mypkt);
-	return err;
 
+	return err;
 }
 
 int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
-- 
1.9.1
