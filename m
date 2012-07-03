Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:51906 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901Ab2GCQtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:49:39 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 02/10] qca-swiss-army-knife: add ar9462-2p0 to the usage text
Date: Tue,  3 Jul 2012 18:42:47 +0200
Message-Id: <1341333775-14091-3-git-send-email-juhosg@openwrt.org> (sfid-20120703_184948_622794_A7191528)
In-Reply-To: <1341333775-14091-1-git-send-email-juhosg@openwrt.org>
References: <1341333775-14091-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/initvals.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 653fdfb..d3740da 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -739,7 +739,7 @@ static void ar9462_2p0_hw_print_initvals(bool check)
 
 static void usage()
 {
-	printf("Usage: initvals [-w] [-f ar5008 | ar9001 | ar9002 | ar9003-2p2 | ar9330-1p1 | ar9330-1p2 | ar9485 | ar9580-1p0 ]\n");
+	printf("Usage: initvals [-w] [-f ar5008 | ar9001 | ar9002 | ar9003-2p2 | ar9330-1p1 | ar9330-1p2 | ar9462-2p0 | ar9485 | ar9580-1p0 ]\n");
 }
 
 static void print_initvals_family(char *family, bool check)
-- 
1.7.2.1

