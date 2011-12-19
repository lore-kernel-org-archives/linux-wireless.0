Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:33992 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab1LSVZP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:25:15 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 03/15] initvals: fix copy&paste error
Date: Mon, 19 Dec 2011 22:24:48 +0100
Message-Id: <1324329900-3923-4-git-send-email-juhosg@openwrt.org> (sfid-20111219_222523_390070_7A3E44AE)
In-Reply-To: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
References: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initvals generates bogus comment in 'ar9485_initvals.h'
due to a copy&paste error.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 initvals.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/initvals.c b/initvals.c
index caa4aa9..c9235d2 100644
--- a/initvals.c
+++ b/initvals.c
@@ -649,7 +649,7 @@ print_initvals_family(char *family, bool check)
 			printf("#ifndef INITVALS_9485_H\n");
 			printf("#define INITVALS_9485_H\n");
 			printf("\n");
-			printf("/* AR9003 2.2 */\n");
+			printf("/* AR9485 1.0 */\n");
 			printf("\n");
 		}
 		ar9485_hw_print_initvals(check);
-- 
1.7.2.1

