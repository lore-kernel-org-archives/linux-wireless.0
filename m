Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:54649 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab0JJIhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 04:37:19 -0400
From: Kalle Valo <kvalo@adurom.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@adurom.com>
Subject: [PATCH 3/3] wl1251: update the new location to the maintainers file
Date: Sun, 10 Oct 2010 11:28:33 +0300
Message-Id: <1286699313-7774-4-git-send-email-kvalo@adurom.com>
In-Reply-To: <1286699313-7774-1-git-send-email-kvalo@adurom.com>
References: <1286699313-7774-1-git-send-email-kvalo@adurom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl1251 is grown up now and can have its own room^H^H^H^Hdirectory.

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2f22257..6431d2f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6425,8 +6425,7 @@ L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
-F:	drivers/net/wireless/wl12xx/*
-X:	drivers/net/wireless/wl12xx/wl1271*
+F:	drivers/net/wireless/wl1251/*
 
 WL1271 WIRELESS DRIVER
 M:	Luciano Coelho <luciano.coelho@nokia.com>
-- 
1.7.0.4

