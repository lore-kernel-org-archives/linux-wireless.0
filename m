Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36446 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760549Ab1LPTTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 14:19:36 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 4/7] initvals: change year in the licence header to 2011
Date: Fri, 16 Dec 2011 20:19:22 +0100
Message-Id: <1324063165-4349-4-git-send-email-juhosg@openwrt.org> (sfid-20111216_201940_096301_3B0A0C15)
In-Reply-To: <1324063165-4349-1-git-send-email-juhosg@openwrt.org>
References: <1324063165-4349-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 initvals.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/initvals.c b/initvals.c
index 8ffd3fd..541fa6b 100644
--- a/initvals.c
+++ b/initvals.c
@@ -222,7 +222,7 @@ typedef long long unsigned int u64;
 static void print_license(void)
 {
 	printf("/*\n");
-	printf(" * Copyright (c) 2010 Atheros Communications Inc.\n");
+	printf(" * Copyright (c) 2011 Atheros Communications Inc.\n");
 	printf(" *\n");
 	printf(" * Permission to use, copy, modify, and/or distribute this software for any\n");
 	printf(" * purpose with or without fee is hereby granted, provided that the above\n");
-- 
1.7.2.1

