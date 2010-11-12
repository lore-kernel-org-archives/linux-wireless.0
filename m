Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47987 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933009Ab0KLXWv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 18:22:51 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: WL1251_SDIO needs WL12XX_PLATFORM_DATA
Date: Sat, 13 Nov 2010 00:22:40 +0100
Message-Id: <1289604160-13383-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1289604160-13383-1-git-send-email-hauke@hauke-m.de>
References: <1289604160-13383-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index 1c5d3d9..4ddf26e 100644
--- a/config.mk
+++ b/config.mk
@@ -489,7 +489,9 @@ CONFIG_SSB_SDIOHOST=y
 CONFIG_B43_SDIO=y
 
 ifdef CONFIG_CRC7
+ifdef CONFIG_WL12XX_PLATFORM_DATA
 CONFIG_WL1251_SDIO=m
+endif #CONFIG_WL12XX_PLATFORM_DATA
 
 ifndef CONFIG_COMPAT_KERNEL_32
 ifdef CONFIG_WL12XX_PLATFORM_DATA
-- 
1.7.1

