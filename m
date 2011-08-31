Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35332 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab1HaWKi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 18:10:38 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: activate CONFIG_B43_PHY_HT
Date: Thu,  1 Sep 2011 00:10:30 +0200
Message-Id: <1314828630-26768-2-git-send-email-hauke@hauke-m.de> (sfid-20110901_001042_586386_4EB1331F)
In-Reply-To: <1314828630-26768-1-git-send-email-hauke@hauke-m.de>
References: <1314828630-26768-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

b43 HT-PHY is working now.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index 7c6bc3b..802bf38 100644
--- a/config.mk
+++ b/config.mk
@@ -273,7 +273,7 @@ CONFIG_B43_LEDS=y
 endif #CONFIG_MAC80211_LEDS
 CONFIG_B43_PHY_LP=y
 CONFIG_B43_PHY_N=y
-# CONFIG_B43_PHY_HT=y
+CONFIG_B43_PHY_HT=y
 # CONFIG_B43_PHY_LCN=y
 # CONFIG_B43_FORCE_PIO=y
 # CONFIG_B43_DEBUG=y
-- 
1.7.4.1

