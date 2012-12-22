Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:49666 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab2LVXSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 18:18:51 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 17/17] cw1200: v2: add to drivers/staging
Date: Sat, 22 Dec 2012 18:18:32 -0500
Message-Id: <1356218312-13616-18-git-send-email-pizza@shaftnet.org> (sfid-20121223_002321_137239_415B5A72)
In-Reply-To: <1356218312-13616-1-git-send-email-pizza@shaftnet.org>
References: <1356218312-13616-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/staging/Kconfig  | 2 ++
 drivers/staging/Makefile | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 329bdb4..ca8b790 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -142,4 +142,6 @@ source "drivers/staging/sb105x/Kconfig"
 
 source "drivers/staging/fwserial/Kconfig"
 
+source "drivers/staging/cw1200/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index c7ec486..58b56c6 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -63,3 +63,4 @@ obj-$(CONFIG_DRM_IMX)		+= imx-drm/
 obj-$(CONFIG_DGRP)		+= dgrp/
 obj-$(CONFIG_SB105X)		+= sb105x/
 obj-$(CONFIG_FIREWIRE_SERIAL)	+= fwserial/
+obj-#(CONFIG_CW1200)		+= cw1200/
-- 
1.7.11.7

