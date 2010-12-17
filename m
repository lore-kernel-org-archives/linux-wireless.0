Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:43180 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab0LQWFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 17:05:31 -0500
Received: by pzk36 with SMTP id 36so234067pzk.11
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 14:05:31 -0800 (PST)
From: Larry.Finger@lwfinger.net
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] MAINTAINERS: Fix typo in rtl8192ce entry
Date: Fri, 17 Dec 2010 16:04:11 -0600
Message-Id: <1292623451-23565-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index eb744aa..12d064f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5063,7 +5063,7 @@ W:	http://linuxwireless.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
 F:	drivers/net/wireless/rtlwifi/
-F:	drivers/net/wireless/rtl8192ce/
+F:	drivers/net/wireless/rtlwifi/rtl8192ce/
 
 S3 SAVAGE FRAMEBUFFER DRIVER
 M:	Antonino Daplas <adaplas@gmail.com>
-- 
1.7.1

