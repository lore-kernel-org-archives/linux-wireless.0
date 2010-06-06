Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40556 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab0FFJMQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 05:12:16 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat-wireless: activate CONFIG_MAC80211_RC_MINSTREL_HT
Date: Sun,  6 Jun 2010 11:11:58 +0200
Message-Id: <1275815518-30281-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1275815518-30281-1-git-send-email-hauke@hauke-m.de>
References: <1275815518-30281-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index b0bb35b..0001a7d 100644
--- a/config.mk
+++ b/config.mk
@@ -130,6 +130,7 @@ CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
 CONFIG_COMPAT_MAC80211_RC_DEFAULT=minstrel
 CONFIG_MAC80211_RC_PID=y
 CONFIG_MAC80211_RC_MINSTREL=y
+CONFIG_MAC80211_RC_MINSTREL_HT=y
 CONFIG_MAC80211_LEDS=y
 
 # enable mesh networking too
-- 
1.7.0.4

