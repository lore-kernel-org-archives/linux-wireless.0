Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eggs.gnu.org ([208.118.235.92]:47804 "EHLO eggs.gnu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbbF2RbJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 13:31:09 -0400
Received: from Debian-exim by eggs.gnu.org with spam-scanned (Exim 4.71)
	(envelope-from <nikolas@gnu.org>)
	id 1Z9ctc-0000gP-VR
	for linux-wireless@vger.kernel.org; Mon, 29 Jun 2015 13:31:09 -0400
From: Nik Nyby <nikolas@gnu.org>
To: linux-wireless@vger.kernel.org, trivial@kernel.org
Cc: Nik Nyby <nikolas@gnu.org>
Subject: [PATCH v2] ath6kl: Trivial: spell "distribution" correctly in a comment.
Date: Mon, 29 Jun 2015 13:30:37 -0400
Message-Id: <1435599037-1369-1-git-send-email-nikolas@gnu.org> (sfid-20150629_193113_886807_F2946C18)
In-Reply-To: <1435378264-13873-1-git-send-email-nikolas@gnu.org>
References: <1435378264-13873-1-git-send-email-nikolas@gnu.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes two misspellings of "distribution" in a comment.

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
2.1.4

