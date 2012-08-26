Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ocean.emcraft.com ([213.221.7.182]:40851 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab2HZN4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 09:56:54 -0400
Subject: Re: [rt2x00-users] [PATCH] compat-wireless:rt2800usb: Fixed a typo
From: Sergei Poselenov <sposelenov@emcraft.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sun, 26 Aug 2012 17:56:51 +0400
In-Reply-To: <20120821114343.GB2380@redhat.com>
References: <20120820205355.7ccc0450@emcraft.com>
	 <20120821114343.GB2380@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Message-ID: <1345989412.8762.6.camel@mehome> (sfid-20120826_155658_250088_4F457FAC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed a typo in the comment.

Cc: stable@vger.kernel.org
Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 6cf3365..f8085b2 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -662,7 +662,7 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 	rx_pkt_len = rt2x00_get_field32(word, RXINFO_W0_USB_DMA_RX_PKT_LEN);
 
 	/*
-	 * Remove the RXINFO structure from the sbk.
+	 * Remove the RXINFO structure from the skb.
 	 */
 	skb_pull(entry->skb, RXINFO_DESC_SIZE);
 
-- 
1.7.4.4



