Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46020 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760315Ab2EKQQr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 12:16:47 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/6] atheros-initvals: update copyright notices
Date: Fri, 11 May 2012 18:16:40 +0200
Message-Id: <1336753001-29583-5-git-send-email-nbd@openwrt.org> (sfid-20120511_181658_133390_E68D9088)
In-Reply-To: <1336753001-29583-4-git-send-email-nbd@openwrt.org>
References: <1336753001-29583-1-git-send-email-nbd@openwrt.org>
 <1336753001-29583-2-git-send-email-nbd@openwrt.org>
 <1336753001-29583-3-git-send-email-nbd@openwrt.org>
 <1336753001-29583-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 initvals.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/initvals.c b/initvals.c
index 8c06690..fe20234 100644
--- a/initvals.c
+++ b/initvals.c
@@ -303,7 +303,7 @@ typedef long long unsigned int u64;
 static void print_license(void)
 {
 	printf("/*\n");
-	printf(" * Copyright (c) 2011 Atheros Communications Inc.\n");
+	printf(" * Copyright (c) 2010-2012 Atheros Communications Inc.\n");
 	printf(" *\n");
 	printf(" * Permission to use, copy, modify, and/or distribute this software for any\n");
 	printf(" * purpose with or without fee is hereby granted, provided that the above\n");
-- 
1.7.3.2

