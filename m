Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41635 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1BBFGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 00:06:38 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/8]drivers:net:ipw2100.c change a typo comamnd to command
Date: Tue,  1 Feb 2011 21:06:21 -0800
Message-Id: <1296623181-5243-1-git-send-email-justinmattock@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The below patch fixes a typo comamnd to command.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wireless/ipw2x00/ipw2100.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 61915f3..da60fae 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -1397,7 +1397,7 @@ static int ipw2100_power_cycle_adapter(struct ipw2100_priv *priv)
 }
 
 /*
- * Send the CARD_DISABLE_PHY_OFF comamnd to the card to disable it
+ * Send the CARD_DISABLE_PHY_OFF command to the card to disable it
  *
  * After disabling, if the card was associated, a STATUS_ASSN_LOST will be sent.
  *
-- 
1.6.5.GIT

