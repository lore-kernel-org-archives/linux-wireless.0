Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36940 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933226AbcHaLra (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Aug 2016 07:47:30 -0400
Received: by mail-wm0-f44.google.com with SMTP id i5so84774483wmg.0
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2016 04:47:29 -0700 (PDT)
From: Jakub Kicinski <jakub.kicinski@netronome.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCHv8 3/4] mt7601u: remove unnecessary include
Date: Wed, 31 Aug 2016 12:46:46 +0100
Message-Id: <1472644007-20959-4-git-send-email-jakub.kicinski@netronome.com> (sfid-20160831_134742_528857_658717E0)
In-Reply-To: <1472644007-20959-1-git-send-email-jakub.kicinski@netronome.com>
References: <1471625049-12643-1-git-send-email-jakub.kicinski@netronome.com>
 <1472644007-20959-1-git-send-email-jakub.kicinski@netronome.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to include linux/version.h in a in-tree
driver.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dinan Gunawardena <dinan.gunawardena@netronome.com>
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
