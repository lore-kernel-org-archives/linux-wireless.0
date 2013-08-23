Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51857 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab3HWI7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 04:59:48 -0400
Received: by mail-lb0-f174.google.com with SMTP id w20so271062lbh.5
        for <linux-wireless@vger.kernel.org>; Fri, 23 Aug 2013 01:59:47 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH v2 16/16] wcn36xx: Add wcn36xx to ath Makefile and Kconfig
Date: Fri, 23 Aug 2013 10:58:19 +0200
Message-Id: <1377248299-21007-17-git-send-email-k.eugene.e@gmail.com> (sfid-20130823_105954_793527_CA6D8AA9)
In-Reply-To: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
References: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
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

