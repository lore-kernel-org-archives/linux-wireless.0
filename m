Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eggs.gnu.org ([208.118.235.92]:38947 "EHLO eggs.gnu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbbF0ELV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Jun 2015 00:11:21 -0400
Received: from Debian-exim by eggs.gnu.org with spam-scanned (Exim 4.71)
	(envelope-from <nikolas@gnu.org>)
	id 1Z8hSa-00064y-9S
	for linux-wireless@vger.kernel.org; Sat, 27 Jun 2015 00:11:20 -0400
From: Nik Nyby <nikolas@gnu.org>
To: kvalo@qca.qualcomm.com, trivial@kernel.org,
	linux-wireless@vger.kernel.org
Cc: Nik Nyby <nikolas@gnu.org>
Subject: [PATCH] Trivial: spell "distribution" correctly in a comment.
Date: Sat, 27 Jun 2015 00:11:04 -0400
Message-Id: <1435378264-13873-1-git-send-email-nikolas@gnu.org> (sfid-20150627_061126_796747_4DA476B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Nik Nyby <nikolas@gnu.org>
---
 drivers/net/wireless/ath/ath6kl/htc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 14cab14..112d8a9 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -427,7 +427,7 @@ struct htc_endpoint_credit_dist {
 };
 
 /*
- * credit distibution code that is passed into the distrbution function,
+ * credit distribution code that is passed into the distribution function,
  * there are mandatory and optional codes that must be handled
  */
 enum htc_credit_dist_reason {
-- 
1.9.1

