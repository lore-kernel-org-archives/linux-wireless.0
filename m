Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:53624 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3ALOHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 09:07:04 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 15/15] cw1200: v3: Add to drivers/staging, and a MAINTAINERS entry
Date: Sat, 12 Jan 2013 09:06:15 -0500
Message-Id: <1357999575-12838-16-git-send-email-pizza@shaftnet.org> (sfid-20130112_152321_919876_BBAE247F)
In-Reply-To: <1357999575-12838-1-git-send-email-pizza@shaftnet.org>
References: <1357999575-12838-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 MAINTAINERS              | 5 +++++
 drivers/staging/Kconfig  | 2 ++
 drivers/staging/Makefile | 1 +
 3 files changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 51ff2ae..faa4d59 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7247,6 +7247,11 @@ M:	Manu Abraham <abraham.manu@gmail.com>
 S:	Odd Fixes
 F:	drivers/staging/crystalhd/
 
+STAGING - CW1200 WLAN DRIVER
+M:	Solomon Peachy <pizza@shaftnet.org>
+S:	Maintained
+F:	drivers/staging/cw1200/
+
 STAGING - ECHO CANCELLER
 M:	Steve Underwood <steveu@coppice.org>
 M:	David Rowe <david@rowetel.com>
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

