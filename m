Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:60487 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab2DXC64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 22:58:56 -0400
Received: by dadz8 with SMTP id z8so276033dad.10
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 19:58:56 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] ath6kl: include in.h explicitly
Date: Mon, 23 Apr 2012 19:58:50 -0700
Message-Id: <1335236330-871-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20120424_045859_580248_8BA21A2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Do not assume anyone before us includes it for us.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 7c8a997..99c113ab 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/ip.h>
+#include <linux/in.h>
 #include "core.h"
 #include "debug.h"
 #include "testmode.h"
-- 
1.7.10.rc1.22.gf5241

