Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36959 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab0LCTIA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 14:08:00 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: add new config options for ath5k
Date: Fri,  3 Dec 2010 20:07:49 +0100
Message-Id: <1291403269-2938-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1291403269-2938-1-git-send-email-hauke@hauke-m.de>
References: <1291403269-2938-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index fcf575d..015f400 100644
--- a/config.mk
+++ b/config.mk
@@ -207,7 +207,9 @@ CONFIG_MAC80211_HWSIM=m
 ifdef CONFIG_PCI
 
 CONFIG_ATH5K=m
+CONFIG_ATH5K_PCI=y
 # CONFIG_ATH5K_DEBUG=y
+# CONFIG_ATH5K_AHB=y
 CONFIG_ATH9K_HW=m
 CONFIG_ATH9K=m
 # Note: once ath9k_htc is added we'll have to move
-- 
1.7.1

