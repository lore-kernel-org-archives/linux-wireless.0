Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:36329 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbcFULpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 07:45:46 -0400
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: kvalo@qca.qualcomm.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/2] ath10k: remove unused <linux/semaphore.h>
Date: Tue, 21 Jun 2016 20:45:38 +0900
Message-Id: <20160621114539.15313-1-chaehyun.lim@gmail.com> (sfid-20160621_134811_696476_6933A88C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<linux/semaphore.h> is not used anymore, so just remove it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htc.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index cc82718..0c55cd9 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -22,7 +22,6 @@
 #include <linux/list.h>
 #include <linux/bug.h>
 #include <linux/skbuff.h>
-#include <linux/semaphore.h>
 #include <linux/timer.h>
 
 struct ath10k;
-- 
2.9.0

