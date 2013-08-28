Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33559 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab3H1H6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 03:58:06 -0400
Received: by mail-lb0-f171.google.com with SMTP id u14so3411914lbd.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Aug 2013 00:58:04 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH v3 16/16] wcn36xx: Add wcn36xx to ath Makefile and Kconfig
Date: Wed, 28 Aug 2013 09:56:46 +0200
Message-Id: <1377676606-23033-17-git-send-email-k.eugene.e@gmail.com> (sfid-20130828_100909_700461_A7BF2E1A)
In-Reply-To: <1377676606-23033-1-git-send-email-k.eugene.e@gmail.com>
References: <1377676606-23033-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now wcn36xx is part of ath family.

Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>
---
 drivers/net/wireless/ath/Kconfig  | 1 +
 drivers/net/wireless/ath/Makefile | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/Kconfig b/drivers/net/wireless/ath/Kconfig
index 1abf1d4..ba81d62 100644
--- a/drivers/net/wireless/ath/Kconfig
+++ b/drivers/net/wireless/ath/Kconfig
@@ -32,5 +32,6 @@ source "drivers/net/wireless/ath/ath6kl/Kconfig"
 source "drivers/net/wireless/ath/ar5523/Kconfig"
 source "drivers/net/wireless/ath/wil6210/Kconfig"
 source "drivers/net/wireless/ath/ath10k/Kconfig"
+source "drivers/net/wireless/ath/wcn36xx/Kconfig"
 
 endif
diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index fb05cfd..363b056 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_ATH6KL)		+= ath6kl/
 obj-$(CONFIG_AR5523)		+= ar5523/
 obj-$(CONFIG_WIL6210)		+= wil6210/
 obj-$(CONFIG_ATH10K)		+= ath10k/
+obj-$(CONFIG_WCN36XX)		+= wcn36xx/
 
 obj-$(CONFIG_ATH_COMMON)	+= ath.o
 
-- 
1.8.2.2

