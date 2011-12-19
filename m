Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:34008 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab1LSVZR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:25:17 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 04/15] initvals: add ar9485_initvals.h to ATH9K_DEPS
Date: Mon, 19 Dec 2011 22:24:49 +0100
Message-Id: <1324329900-3923-5-git-send-email-juhosg@openwrt.org> (sfid-20111219_222524_854093_E10A5E1E)
In-Reply-To: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
References: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 67d09d5..1194504 100644
--- a/Makefile
+++ b/Makefile
@@ -21,6 +21,7 @@ ATH9K_DEPS += \
 	ar9003_2p2_initvals.h	\
 	ar9330_1p1_initvals.h	\
 	ar9330_1p2_initvals.h	\
+	ar9485_initvals.h	\
 	ar9580_1p0_initvals.h
 
 initvals: $(ATH9K_DEPS) $(ATHEROS_DEPS) initvals.c
-- 
1.7.2.1

