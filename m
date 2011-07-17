Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:47616 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852Ab1GQHGw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 03:06:52 -0400
Received: by mail-fx0-f51.google.com with SMTP id 10so5490924fxh.24
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 00:06:50 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, kvalo@adurom.com
Subject: [PATCH] MAINTAINERS: change maintainer of the wl1251 driver
Date: Sun, 17 Jul 2011 10:06:34 +0300
Message-Id: <1310886394-25951-1-git-send-email-coelho@ti.com> (sfid-20110717_090700_974400_843319F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo has asked me to take over the maintenance of the wl1251
driver.  Thanks Kalle for all his work on the wl1251 driver, I'll try
to keep up with his good work from now on.

At the same time, update the Web URL to something more specific.
There's not much in that page, but we will try to update it soon.

Cc: Kalle Valo <kvalo@adurom.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 MAINTAINERS |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 21afb51..e171a63 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6944,9 +6944,9 @@ S:	Maintained
 F:	drivers/input/misc/wistron_btns.c
 
 WL1251 WIRELESS DRIVER
-M:	Kalle Valo <kvalo@adurom.com>
+M:	Luciano Coelho <coelho@ti.com>
 L:	linux-wireless@vger.kernel.org
-W:	http://wireless.kernel.org
+W:	http://wireless.kernel.org/en/users/Drivers/wl1251
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
 F:	drivers/net/wireless/wl1251/*
-- 
1.7.1

