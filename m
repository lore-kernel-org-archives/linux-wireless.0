Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns1.siteground211.com ([209.62.36.12]:54860 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbYHRT5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 15:57:07 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH] net: rfkill: add missing line break
Date: Mon, 18 Aug 2008 22:56:53 +0300
Message-Id: <1219089413-7884-1-git-send-email-me@felipebalbi.com> (sfid-20080818_215712_246596_41A276EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felipe Balbi <felipe.balbi@nokia.com>

Trivial patch adding a missing line break on
rfkill_claim_show().

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 net/rfkill/rfkill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index d2d4565..3bc78b0 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -372,7 +372,7 @@ static ssize_t rfkill_claim_show(struct device *dev,
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
-	return sprintf(buf, "%d", rfkill->user_claim);
+	return sprintf(buf, "%d\n", rfkill->user_claim);
 }
 
 static ssize_t rfkill_claim_store(struct device *dev,
-- 
1.6.0.rc3.10.g5a13c

