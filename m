Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65363 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab1DHMXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 08:23:19 -0400
Received: by eyx24 with SMTP id 24so1087986eyx.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 05:23:18 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH][2.6.39?] b43: trivial: update module info about firmware
Date: Fri,  8 Apr 2011 15:00:32 +0200
Message-Id: <1302267632-2326-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
We do not use ucode9, but we started using ucode16_mimo for N-PHY support (high
cores).

John: is that OK to take this for .39?
---
 drivers/net/wireless/b43/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 906dfe6..705efd3 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -72,8 +72,8 @@ MODULE_FIRMWARE("b43/ucode11.fw");
 MODULE_FIRMWARE("b43/ucode13.fw");
 MODULE_FIRMWARE("b43/ucode14.fw");
 MODULE_FIRMWARE("b43/ucode15.fw");
+MODULE_FIRMWARE("b43/ucode16_mimo");
 MODULE_FIRMWARE("b43/ucode5.fw");
-MODULE_FIRMWARE("b43/ucode9.fw");
 
 static int modparam_bad_frames_preempt;
 module_param_named(bad_frames_preempt, modparam_bad_frames_preempt, int, 0444);
-- 
1.7.3.4

