Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64431 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbZH1UeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 16:34:20 -0400
Received: by bwz19 with SMTP id 19so1816596bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2009 13:34:21 -0700 (PDT)
Message-ID: <4A983F4D.90805@gmail.com>
Date: Fri, 28 Aug 2009 22:34:21 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	trivial@kernel.org
Subject: [PATCH] b43: Fix typo in modparam_btcoex description
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 1263f4b..f2c5b2d 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -91,7 +91,7 @@ MODULE_PARM_DESC(qos, "Enable QOS support (default on)");
 
 static int modparam_btcoex = 1;
 module_param_named(btcoex, modparam_btcoex, int, 0444);
-MODULE_PARM_DESC(btcoex, "Enable Bluetooth coexistance (default on)");
+MODULE_PARM_DESC(btcoex, "Enable Bluetooth coexistence (default on)");
 
 int b43_modparam_verbose = B43_VERBOSITY_DEFAULT;
 module_param_named(verbose, b43_modparam_verbose, int, 0644);
-- 
1.6.2.4



