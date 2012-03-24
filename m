Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40388 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab2CXHhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Mar 2012 03:37:52 -0400
Received: by obbeh20 with SMTP id eh20so3103094obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 24 Mar 2012 00:37:51 -0700 (PDT)
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: linville@tuxdriver.com
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH] MAINTAINERS: adding maintainer for ipw2x00
Date: Sat, 24 Mar 2012 03:41:01 -0400
Message-Id: <1332574861-1479-1-git-send-email-stas.yakovlev@gmail.com> (sfid-20120324_083756_041625_36F801C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add myself as maintainer as suggested by Stanislaw Gruszka.

Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
---
 MAINTAINERS |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 22186f5..cd3b39d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3519,17 +3519,13 @@ L:	linux-pm@vger.kernel.org
 S:	Supported
 F:	arch/x86/platform/mrst/pmu.*
 
-INTEL PRO/WIRELESS 2100 NETWORK CONNECTION SUPPORT
+INTEL PRO/WIRELESS 2100, 2200BG, 2915ABG NETWORK CONNECTION SUPPORT
+M:	Stanislav Yakovlev <stas.yakovlev@gmail.com>
 L:	linux-wireless@vger.kernel.org
-S:	Orphan
+S:	Maintained
 F:	Documentation/networking/README.ipw2100
-F:	drivers/net/wireless/ipw2x00/ipw2100.*
-
-INTEL PRO/WIRELESS 2915ABG NETWORK CONNECTION SUPPORT
-L:	linux-wireless@vger.kernel.org
-S:	Orphan
 F:	Documentation/networking/README.ipw2200
-F:	drivers/net/wireless/ipw2x00/ipw2200.*
+F:	drivers/net/wireless/ipw2x00/
 
 INTEL(R) TRUSTED EXECUTION TECHNOLOGY (TXT)
 M:	Joseph Cihula <joseph.cihula@intel.com>
-- 
1.7.2.5

