Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37209 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946511Ab2LFSRd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 13:17:33 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 04/13] qca-swiss-army-knife: fix comment in ar9340_initvals.h
Date: Thu,  6 Dec 2012 19:17:18 +0100
Message-Id: <1354817847-23440-5-git-send-email-juhosg@openwrt.org> (sfid-20121206_192412_486474_90CF173C)
In-Reply-To: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
References: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The comment at the end of the 'ar9340_initvals.h'
header does not match with defined constant. Fix it.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/ar9340_initvals.h |    2 +-
 tools/initvals/initvals.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/initvals/ar9340_initvals.h b/tools/initvals/ar9340_initvals.h
index dfc202e..1d8235e 100644
--- a/tools/initvals/ar9340_initvals.h
+++ b/tools/initvals/ar9340_initvals.h
@@ -1345,4 +1345,4 @@ static const u32 ar9340_1p0_soc_preamble[][2] = {
 	{0x00007038, 0x000004c2},
 };
 
-#endif /* INITVALS_9340_1P0_H */
+#endif /* INITVALS_9340_H */
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index c93a3d1..cb0bbbf 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -846,7 +846,7 @@ static void print_initvals_family(char *family, bool check)
 		}
 		ar9340_hw_print_initvals(check);
 		if (!check)
-			printf("#endif /* INITVALS_9340_1P0_H */\n");
+			printf("#endif /* INITVALS_9340_H */\n");
 	} else if (strncmp(family, "ar9485", 6) == 0) {
 		if (!check) {
 			printf("#ifndef INITVALS_9485_H\n");
-- 
1.7.10

