Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34746 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759523Ab2EKQj7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 12:39:59 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 5/6] atheros-initvals: update copyright notices
Date: Fri, 11 May 2012 18:39:55 +0200
Message-Id: <1336754396-30216-5-git-send-email-nbd@openwrt.org> (sfid-20120511_184012_414667_9A7F951C)
In-Reply-To: <1336754396-30216-4-git-send-email-nbd@openwrt.org>
References: <1336754396-30216-1-git-send-email-nbd@openwrt.org>
 <1336754396-30216-2-git-send-email-nbd@openwrt.org>
 <1336754396-30216-3-git-send-email-nbd@openwrt.org>
 <1336754396-30216-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 initvals.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/initvals.c b/initvals.c
index 8c06690..41744b4 100644
--- a/initvals.c
+++ b/initvals.c
@@ -303,7 +303,8 @@ typedef long long unsigned int u64;
 static void print_license(void)
 {
 	printf("/*\n");
-	printf(" * Copyright (c) 2011 Atheros Communications Inc.\n");
+	printf(" * Copyright (c) 2010-2011 Atheros Communications Inc.\n");
+	printf(" * Copyright (c) 2011-2012 Qualcomm Atheros Inc.\n");
 	printf(" *\n");
 	printf(" * Permission to use, copy, modify, and/or distribute this software for any\n");
 	printf(" * purpose with or without fee is hereby granted, provided that the above\n");
-- 
1.7.3.2

