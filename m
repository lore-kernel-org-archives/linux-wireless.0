Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:33981 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287Ab1LSVZP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:25:15 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 02/15] initvals: fix typos in usage text
Date: Mon, 19 Dec 2011 22:24:47 +0100
Message-Id: <1324329900-3923-3-git-send-email-juhosg@openwrt.org> (sfid-20111219_222521_674050_F531B19C)
In-Reply-To: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
References: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 initvals.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/initvals.c b/initvals.c
index 5923823..caa4aa9 100644
--- a/initvals.c
+++ b/initvals.c
@@ -601,7 +601,7 @@ static void ar9580_1p0_hw_print_initvals(bool check)
 
 static void usage()
 {
-	printf("Usage: initvals [-w] [-f ar5008 | ar9001 | ar9002 | ar9003-2p2 | ar9300-1p1 | ar9300-1p2 | ar9485 | ar9580-1p0 ]\n");
+	printf("Usage: initvals [-w] [-f ar5008 | ar9001 | ar9002 | ar9003-2p2 | ar9330-1p1 | ar9330-1p2 | ar9485 | ar9580-1p0 ]\n");
 }
 
 print_initvals_family(char *family, bool check)
-- 
1.7.2.1

