Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4355 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab0AGS4N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 13:56:13 -0500
To: mb@bu3sch.de, stefano.brivio@polimi.it
Subject: [PATCH] b43: Declare all possible firmware files.
Cc: linux-wireless@vger.kernel.org
Message-Id: <20100107183517.A322FF88D8@sepang.rtg.net>
Date: Thu,  7 Jan 2010 11:35:17 -0700 (MST)
From: timg@tpi.com (Tim Gardner)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 2c1f1895ef2aa8f0e5497893eff71304aef332e1:
  Linus Torvalds (1):
        Merge branch 'drm-linus' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://kernel.ubuntu.com/rtg/linux-2.6 b43

Tim Gardner (1):
      b43: Declare all possible firmware files.

 drivers/net/wireless/b43/main.c |   34 ++++++++++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 2 deletions(-)

>From def1157eaeb397f0afab25b91db8bab3fcb8816c Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Thu, 7 Jan 2010 11:10:38 -0700
Subject: [PATCH] b43: Declare all possible firmware files.

BugLink: http://bugs.launchpad.net/bugs/488636

Enhances module information with the names of the firmware files
that could be used by this driver. This helps tools like Jockey to
correctly detect and/or install the firmware files relevant to
this driver.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/net/wireless/b43/main.c |   34 ++++++++++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 4c41cfe..03e48c4 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -66,8 +66,38 @@ MODULE_AUTHOR("Michael Buesch");
 MODULE_AUTHOR("Gábor Stefanik");
 MODULE_LICENSE("GPL");
 
-MODULE_FIRMWARE(B43_SUPPORTED_FIRMWARE_ID);
-
+MODULE_FIRMWARE("b43/a0g0bsinitvals5.fw");
+MODULE_FIRMWARE("b43/a0g0bsinitvals9.fw");
+MODULE_FIRMWARE("b43/a0g0initvals5.fw");
+MODULE_FIRMWARE("b43/a0g0initvals9.fw");
+MODULE_FIRMWARE("b43/a0g1bsinitvals13.fw");
+MODULE_FIRMWARE("b43/a0g1bsinitvals5.fw");
+MODULE_FIRMWARE("b43/a0g1bsinitvals9.fw");
+MODULE_FIRMWARE("b43/a0g1initvals13.fw");
+MODULE_FIRMWARE("b43/a0g1initvals5.fw");
+MODULE_FIRMWARE("b43/a0g1initvals9.fw");
+MODULE_FIRMWARE("b43/b0g0bsinitvals13.fw");
+MODULE_FIRMWARE("b43/b0g0bsinitvals5.fw");
+MODULE_FIRMWARE("b43/b0g0bsinitvals9.fw");
+MODULE_FIRMWARE("b43/b0g0initvals13.fw");
+MODULE_FIRMWARE("b43/b0g0initvals5.fw");
+MODULE_FIRMWARE("b43/b0g0initvals9.fw");
+MODULE_FIRMWARE("b43/lp0bsinitvals13.fw");
+MODULE_FIRMWARE("b43/lp0bsinitvals14.fw");
+MODULE_FIRMWARE("b43/lp0bsinitvals15.fw");
+MODULE_FIRMWARE("b43/lp0initvals13.fw");
+MODULE_FIRMWARE("b43/lp0initvals14.fw");
+MODULE_FIRMWARE("b43/lp0initvals15.fw");
+MODULE_FIRMWARE("b43/n0absinitvals11.fw");
+MODULE_FIRMWARE("b43/n0bsinitvals11.fw");
+MODULE_FIRMWARE("b43/n0initvals11.fw");
+MODULE_FIRMWARE("b43/pcm5.fw");
+MODULE_FIRMWARE("b43/ucode11.fw");
+MODULE_FIRMWARE("b43/ucode13.fw");
+MODULE_FIRMWARE("b43/ucode14.fw");
+MODULE_FIRMWARE("b43/ucode15.fw");
+MODULE_FIRMWARE("b43/ucode5.fw");
+MODULE_FIRMWARE("b43/ucode9.fw");
 
 static int modparam_bad_frames_preempt;
 module_param_named(bad_frames_preempt, modparam_bad_frames_preempt, int, 0444);
-- 
1.6.2.4

