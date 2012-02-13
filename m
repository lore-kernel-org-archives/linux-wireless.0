Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab2BMKZK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:25:10 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 24/24] iwlegacy: remove il_is_rfkill_hw
Date: Mon, 13 Feb 2012 11:23:31 +0100
Message-Id: <1329128611-6815-25-git-send-email-sgruszka@redhat.com> (sfid-20120213_112516_462038_32841F4D)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.h |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index cee72f1..6ed9871 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1945,15 +1945,9 @@ il_is_init(struct il_priv *il)
 }
 
 static inline int
-il_is_rfkill_hw(struct il_priv *il)
-{
-	return test_bit(S_RFKILL, &il->status);
-}
-
-static inline int
 il_is_rfkill(struct il_priv *il)
 {
-	return il_is_rfkill_hw(il);
+	return test_bit(S_RFKILL, &il->status);
 }
 
 static inline int
-- 
1.7.1

