Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35550 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbbJOTby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 15:31:54 -0400
Received: by qkap81 with SMTP id p81so44701932qka.2
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2015 12:31:53 -0700 (PDT)
From: Joaquin Ignacio Barotto <joaquinbarotto@gmail.com>
To: lauro.venancio@openbossa.org
Cc: linux-wireless@vger.kernel.org,
	Joaquin Ignacio Barotto <joaquinbarotto@gmail.com>
Subject: [PATCH] Staging: nfc: Fix comment style
Date: Thu, 15 Oct 2015 16:32:28 -0300
Message-Id: <1444937548-2381-1-git-send-email-joaquinbarotto@gmail.com> (sfid-20151015_213158_165563_DB167629)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cosmetic fix to a comment to comply with the coding style.

Signed-off-by: Joaquin Ignacio Barotto <joaquinbarotto@gmail.com>
---
 drivers/nfc/nfcwilink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcwilink.c b/drivers/nfc/nfcwilink.c
index ce2e2cf..62907ef 100644
--- a/drivers/nfc/nfcwilink.c
+++ b/drivers/nfc/nfcwilink.c
@@ -348,7 +348,8 @@ static long nfcwilink_receive(void *priv_data, struct sk_buff *skb)
 	dev_dbg(&drv->pdev->dev, "receive entry, len %d\n", skb->len);
 
 	/* strip the ST header
-	(apart for the chnl byte, which is not received in the hdr) */
+	 * (apart for the chnl byte, which is not received in the hdr)
+	 */
 	skb_pull(skb, (NFCWILINK_HDR_LEN-1));
 
 	if (test_bit(NFCWILINK_FW_DOWNLOAD, &drv->flags)) {
-- 
2.6.1

