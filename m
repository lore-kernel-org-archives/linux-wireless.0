Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57429 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762661AbXLMG7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:47 -0500
Subject: [PATCH 81/48] libertas: add missing newline on debug message
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i34-0005tX-A6@shinybook.infradead.org> (sfid-20071213_070015_281165_1D073CDD)
Date: Thu, 13 Dec 2007 01:59:58 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 19:57:05 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/assoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index bd9cfe1..a4b9756 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -219,7 +219,7 @@ static int assoc_helper_channel(struct lbs_private *priv,
 		lbs_deb_assoc("ASSOC: channel: error getting channel.");
 
 	if (assoc_req->channel != priv->curbssparams.channel) {
-		lbs_deb_assoc("ASSOC: channel: failed to update channel to %d",
+		lbs_deb_assoc("ASSOC: channel: failed to update channel to %d\n",
 		              assoc_req->channel);
 		goto done;
 	}
-- 
1.5.3.4

