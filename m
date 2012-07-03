Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:51909 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756987Ab2GCQtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:49:39 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 01/10] qca-swiss-army-knife: fix string length for ar9340
Date: Tue,  3 Jul 2012 18:42:46 +0200
Message-Id: <1341333775-14091-2-git-send-email-juhosg@openwrt.org> (sfid-20120703_184945_964201_6562E3C9)
In-Reply-To: <1341333775-14091-1-git-send-email-juhosg@openwrt.org>
References: <1341333775-14091-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/initvals.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index a19dca2..653fdfb 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -782,7 +782,7 @@ static void print_initvals_family(char *family, bool check)
 		ar9330_1p2_hw_print_initvals(check);
 		if (!check)
 			printf("#endif /* INITVALS_9330_1P2_H */\n");
-	} else if (strncmp(family, "ar9340", 10) == 0) {
+	} else if (strncmp(family, "ar9340", 6) == 0) {
 		if (!check) {
 			printf("#ifndef INITVALS_9340_H\n");
 			printf("#define INITVALS_9340_H\n");
-- 
1.7.2.1

