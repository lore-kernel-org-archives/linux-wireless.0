Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53208 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754592AbYHZO6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2008 10:58:07 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 2/5] rfkill: add missing line break
Date: Tue, 26 Aug 2008 11:57:58 -0300
Message-Id: <1219762681-26911-3-git-send-email-hmh@hmh.eng.br> (sfid-20080826_165815_239946_955DFCF5)
In-Reply-To: <1219762681-26911-1-git-send-email-hmh@hmh.eng.br>
References: <1219762681-26911-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felipe Balbi <felipe.balbi@nokia.com>

Trivial patch adding a missing line break on
rfkill_claim_show().

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.co>
---
 net/rfkill/rfkill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 173d039..b630f35 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -431,7 +431,7 @@ static ssize_t rfkill_claim_show(struct device *dev,
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
-	return sprintf(buf, "%d", rfkill->user_claim);
+	return sprintf(buf, "%d\n", rfkill->user_claim);
 }
 
 static ssize_t rfkill_claim_store(struct device *dev,
-- 
1.5.6.3

