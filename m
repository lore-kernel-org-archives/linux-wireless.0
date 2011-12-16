Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36403 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab1LPTTb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 14:19:31 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/7] initvals: add ar9580_1p0_initvals.h to dependency list
Date: Fri, 16 Dec 2011 20:19:20 +0100
Message-Id: <1324063165-4349-2-git-send-email-juhosg@openwrt.org> (sfid-20111216_201934_839309_F0AC106F)
In-Reply-To: <1324063165-4349-1-git-send-email-juhosg@openwrt.org>
References: <1324063165-4349-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index facbd2a..e5a53b3 100644
--- a/Makefile
+++ b/Makefile
@@ -16,7 +16,8 @@ ATH9K_DEPS += \
 	ar5008_initvals.h 	\
 	ar9001_initvals.h	\
 	ar9002_initvals.h 	\
-	ar9003_2p2_initvals.h
+	ar9003_2p2_initvals.h	\
+	ar9580_1p0_initvals.h
 
 initvals: $(ATH9K_DEPS) $(ATHEROS_DEPS) initvals.c
 	gcc $(CFLAGS) -o $@ $@.c
-- 
1.7.2.1

