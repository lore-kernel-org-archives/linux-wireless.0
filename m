Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.143.5]:20979 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727296AbeIDAkL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 20:40:11 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 4F5DA6C477
        for <linux-wireless@vger.kernel.org>; Mon,  3 Sep 2018 15:18:23 -0500 (CDT)
Date: Mon, 3 Sep 2018 15:17:52 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] orinoco_usb: fix spelling mistake in fall-through annotation
Message-ID: <20180903201752.GA25288@embeddedor.com> (sfid-20180903_221834_033604_9E55C62F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace "fall though" with a proper "fall through" annotation.

This fix is part of the ongoing efforts to enabling
-Wimplicit-fallthrough

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
index d8c2720..21bb684 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -911,7 +911,7 @@ static int ezusb_access_ltv(struct ezusb_priv *upriv,
 	default:
 		err("%s: Unexpected context state %d", __func__,
 		    state);
-		/* fall though */
+		/* fall through */
 	case EZUSB_CTX_REQ_TIMEOUT:
 	case EZUSB_CTX_REQ_FAILED:
 	case EZUSB_CTX_RESP_TIMEOUT:
-- 
2.7.4
