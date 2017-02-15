Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50172 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751574AbdBOJaY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:30:24 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH v2 10/10] rt2x00: fix rt2x00debug_dump_frame comment
Date: Wed, 15 Feb 2017 10:25:13 +0100
Message-Id: <1487150713-3510-11-git-send-email-sgruszka@redhat.com> (sfid-20170215_103028_478954_3D37AA6B)
In-Reply-To: <1487150713-3510-1-git-send-email-sgruszka@redhat.com>
References: <1487150713-3510-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Jeroen Roovers <jer@airfi.aero>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index efd6914..233ee8b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -1396,7 +1396,7 @@ struct queue_entry *rt2x00queue_get_entry(struct data_queue *queue,
  * rt2x00debug_dump_frame - Dump a frame to userspace through debugfs.
  * @rt2x00dev: Pointer to &struct rt2x00_dev.
  * @type: The type of frame that is being dumped.
- * @skb: The skb containing the frame to be dumped.
+ * @entry: The queue entry containing the frame to be dumped.
  */
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
-- 
1.8.3.1
