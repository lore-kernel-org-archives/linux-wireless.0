Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:50612 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754875AbZKWHQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 02:16:34 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 4/6] rt2x00: Fix typo (lengt --> length) in rt2x00queue.c
Date: Mon, 23 Nov 2009 08:16:03 +0100
Message-Id: <1258960565-26736-5-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1258960565-26736-4-git-send-email-gwingerde@gmail.com>
References: <1258960565-26736-1-git-send-email-gwingerde@gmail.com>
 <1258960565-26736-2-git-send-email-gwingerde@gmail.com>
 <1258960565-26736-3-git-send-email-gwingerde@gmail.com>
 <1258960565-26736-4-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
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

