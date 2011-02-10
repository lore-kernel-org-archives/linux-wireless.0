Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36790 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab1BJP06 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 10:26:58 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/4] compat-wireless: activate BRCMFMAC
Date: Thu, 10 Feb 2011 16:26:30 +0100
Message-Id: <1297351590-24019-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1297351590-24019-1-git-send-email-hauke@hauke-m.de>
References: <1297351590-24019-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is now possible to build BRCMFMAC and BRCMSMAC.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/config.mk b/config.mk
index 9a206d9..e7f04ea 100644
--- a/config.mk
+++ b/config.mk
@@ -557,9 +557,7 @@ CONFIG_ATH6KL_ENABLE_TARGET_DEBUG_PRINTS=y
 CONFIG_ATH6KL_VIRTUAL_SCATTER_GATHER=y
 CONFIG_ATH6K_LEGACY=m
 
-# It is not possible to compile CONFIG_BRCMSMAC and CONFIG_BRCMFMAC as
-# module at the same time
-# CONFIG_BRCMFMAC=y
+CONFIG_BRCMFMAC=y
 
 endif #CONFIG_WIRELESS_EXT
 endif #CONFIG_MMC
-- 
1.7.1

