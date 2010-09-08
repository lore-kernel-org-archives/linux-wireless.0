Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:50266 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab0IHXZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:25:57 -0400
Received: by pxi10 with SMTP id 10so254012pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:25:57 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Thomas Klute <thomas2.klute@uni-dortmund.de>,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH 2/9] libertas_tf: deb_defs.h: Fix include guard
Date: Wed,  8 Sep 2010 16:25:22 -0700
Message-Id: <1283988329-44549-3-git-send-email-steve@cozybit.com>
In-Reply-To: <1283988329-44549-1-git-send-email-steve@cozybit.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Klute <thomas2.klute@uni-dortmund.de>

Compiling with CONFIG_LIBERTAS_THINFIRM_DEBUG=y failed before, this was
the reason.

Signed-off-by: Thomas Klute <thomas2.klute@uni-dortmund.de>
Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/libertas_tf/deb_defs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/deb_defs.h b/drivers/net/wireless/libertas_tf/deb_defs.h
index e2f009c..99a7478 100644
--- a/drivers/net/wireless/libertas_tf/deb_defs.h
+++ b/drivers/net/wireless/libertas_tf/deb_defs.h
@@ -3,7 +3,7 @@
   * global variable declaration.
   */
 #ifndef _LBS_DEB_DEFS_H_
-#define _LBS_DEB_EFS_H_
+#define _LBS_DEB_DEFS_H_
 
 #ifndef DRV_NAME
 #define DRV_NAME "libertas_tf"
-- 
1.7.0

