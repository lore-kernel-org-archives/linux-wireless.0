Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:63828 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab0I1JUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 05:20:15 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <liville@tuxdriver.com>
Subject: [PATCH] MAINTAINERS: Update git url for the wl1271 driver
Date: Tue, 28 Sep 2010 12:19:57 +0300
Message-Id: <1285665597-31547-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are integrating wl1271 commits via a new git tree now and wl1271
development should be made on top of the new tree.

Update the repository url accordingly.

Cc: John W. Linville <liville@tuxdriver.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6cb1c75..a130d9f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6321,7 +6321,7 @@ WL1271 WIRELESS DRIVER
 M:	Luciano Coelho <luciano.coelho@nokia.com>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git
 S:	Maintained
 F:	drivers/net/wireless/wl12xx/wl1271*
 F:	include/linux/wl12xx.h
-- 
1.6.3.3

