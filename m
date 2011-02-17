Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37001 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab1BQWtx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:49:53 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: Add drivers/net/wireless/rtlwifi/rtl8192c
Date: Thu, 17 Feb 2011 23:49:39 +0100
Message-Id: <1297982979-7592-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1297982979-7592-1-git-send-email-hauke@hauke-m.de>
References: <1297982979-7592-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This directory is needed for rtlwifi.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/admin-update.sh |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 6fe49ce..d0eda2f 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -232,6 +232,7 @@ DRIVERS="$DRIVERS drivers/net/wireless/rtl818x"
 DRIVERS="$DRIVERS drivers/net/wireless/rtl818x/rtl8180"
 DRIVERS="$DRIVERS drivers/net/wireless/rtl818x/rtl8187"
 DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi"
+DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi/rtl8192c"
 DRIVERS="$DRIVERS drivers/net/wireless/rtlwifi/rtl8192ce"
 DRIVERS="$DRIVERS drivers/net/wireless/libertas_tf"
 DRIVERS="$DRIVERS drivers/net/wireless/ipw2x00"
-- 
1.7.1

