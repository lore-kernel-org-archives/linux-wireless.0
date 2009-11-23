Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:58488 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757157AbZKWVpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 16:45:06 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2 4/8] rt2x00: Fix typo (lengt --> length) in rt2x00queue.c
Date: Mon, 23 Nov 2009 22:44:50 +0100
Message-Id: <1259012694-14869-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259012694-14869-4-git-send-email-gwingerde@gmail.com>
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-2-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-3-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-4-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <ivdoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index eaedee8..32d4aea 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -162,10 +162,10 @@ void rt2x00queue_align_frame(struct sk_buff *skb)
 	skb_trim(skb, frame_length);
 }
 
-void rt2x00queue_align_payload(struct sk_buff *skb, unsigned int header_lengt)
+void rt2x00queue_align_payload(struct sk_buff *skb, unsigned int header_length)
 {
 	unsigned int frame_length = skb->len;
-	unsigned int align = ALIGN_SIZE(skb, header_lengt);
+	unsigned int align = ALIGN_SIZE(skb, header_length);
 
 	if (!align)
 		return;
-- 
1.6.5.3

