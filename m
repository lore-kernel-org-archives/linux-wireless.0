Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60037 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab1GVQuc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 12:50:32 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/5] compat-wireless: activate bcma support in b43
Date: Fri, 22 Jul 2011 18:50:15 +0200
Message-Id: <1311353415-30952-5-git-send-email-hauke@hauke-m.de> (sfid-20110722_185035_648614_A884DE7B)
In-Reply-To: <1311353415-30952-1-git-send-email-hauke@hauke-m.de>
References: <1311353415-30952-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/config.mk b/config.mk
index c7ed0a0..786891d 100644
--- a/config.mk
+++ b/config.mk
@@ -334,8 +334,8 @@ CONFIG_BCMA=m
 CONFIG_BCMA_BLOCKIO=y
 CONFIG_BCMA_HOST_PCI=y
 # CONFIG_BCMA_DEBUG=y
-# CONFIG_B43_BCMA=y
-# CONFIG_B43_BCMA_PIO=y
+CONFIG_B43_BCMA=y
+CONFIG_B43_BCMA_PIO=y
 
 CONFIG_P54_PCI=m
 
-- 
1.7.4.1

