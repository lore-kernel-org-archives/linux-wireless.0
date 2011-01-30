Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41674 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab1A3MYu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:50 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so2146783eye.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:50 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 16/21] rt2x00: trivial: add \n to WARNING message
Date: Sun, 30 Jan 2011 13:22:22 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301321.42168.IvDoorn@gmail.com> <201101301322.04131.IvDoorn@gmail.com>
In-Reply-To: <201101301322.04131.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301322.23247.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Stezenbach <js@sig21.net>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 7d7fbe0..fa17c83 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -913,7 +913,7 @@ void rt2x00queue_flush_queue(struct data_queue *queue, bool drop)
 	 * The queue flush has failed...
 	 */
 	if (unlikely(!rt2x00queue_empty(queue)))
-		WARNING(queue->rt2x00dev, "Queue %d failed to flush", queue->qid);
+		WARNING(queue->rt2x00dev, "Queue %d failed to flush\n", queue->qid);
 
 	/*
 	 * Restore the queue to the previous status
-- 
1.7.2.3

