Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37220 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946516Ab2LFSRd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 13:17:33 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 07/13] qca-swiss-army-knife: add ar9462-2p0 to the usage text
Date: Thu,  6 Dec 2012 19:17:21 +0100
Message-Id: <1354817847-23440-8-git-send-email-juhosg@openwrt.org> (sfid-20121206_192412_756351_6F32E80E)
In-Reply-To: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
References: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/initvals.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index cff2c4e..0ab4d7f 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -795,7 +795,7 @@ static void usage()
 {
 	printf("Usage: initvals [-w] "
 	       "[-f ar5008 | ar9001 | ar9002 | "
-	       "ar9003-2p2 | ar9330-1p1 | ar9330-1p2 | ar9485 | ar9580-1p0 | ar9565-1p0 ]\n");
+	       "ar9003-2p2 | ar9330-1p1 | ar9330-1p2 | ar9462-2p0 | ar9485 | ar9580-1p0 | ar9565-1p0 ]\n");
 }
 
 static void print_initvals_family(char *family, bool check)
-- 
1.7.10

