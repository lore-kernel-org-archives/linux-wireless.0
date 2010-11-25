Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52978 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab0KYOsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 09:48:54 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/5] compat-wireless: remove double definition of CONFIG_SSB_DEBUG
Date: Thu, 25 Nov 2010 15:48:37 +0100
Message-Id: <1290696517-20437-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1290696517-20437-1-git-send-email-hauke@hauke-m.de>
References: <1290696517-20437-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index 38477b8..fcf575d 100644
--- a/config.mk
+++ b/config.mk
@@ -286,7 +286,6 @@ endif #CONFIG_WIRELESS_EXT
 ifdef CONFIG_SSB
 # Sonics Silicon Backplane
 CONFIG_SSB_SPROM=y
-# CONFIG_SSB_DEBUG=y
 
 CONFIG_SSB_BLOCKIO=y
 CONFIG_SSB_PCIHOST=y
-- 
1.7.1

