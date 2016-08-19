Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36028 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754172AbcHSQon (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 12:44:43 -0400
Received: by mail-wm0-f49.google.com with SMTP id q128so41478877wma.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Aug 2016 09:44:43 -0700 (PDT)
From: Jakub Kicinski <jakub.kicinski@netronome.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCHv7 3/4] mt7601u: remove unnecessary include
Date: Fri, 19 Aug 2016 17:44:08 +0100
Message-Id: <1471625049-12643-4-git-send-email-jakub.kicinski@netronome.com> (sfid-20160819_184450_586187_C20974C1)
In-Reply-To: <1471625049-12643-1-git-send-email-jakub.kicinski@netronome.com>
References: <1471625049-12643-1-git-send-email-jakub.kicinski@netronome.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to include linux/version.h in a in-tree
driver.

Reviewed-by: Dinan Gunawardena <dinan.gunawardena@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/wireless/mediatek/mt7601u/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/main.c b/drivers/net/wireless/mediatek/mt7601u/main.c
index e70dd9523911..43ebd460ba86 100644
--- a/drivers/net/wireless/mediatek/mt7601u/main.c
+++ b/drivers/net/wireless/mediatek/mt7601u/main.c
@@ -15,7 +15,6 @@
 #include "mt7601u.h"
 #include "mac.h"
 #include <linux/etherdevice.h>
-#include <linux/version.h>
 
 static int mt7601u_start(struct ieee80211_hw *hw)
 {
-- 
1.9.1
