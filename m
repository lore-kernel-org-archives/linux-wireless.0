Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:50635 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab0I1KZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 06:25:31 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Joe Perches <joe@perches.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] MAINTAINERS: Update git url for the wl1271 driver
Date: Tue, 28 Sep 2010 13:25:04 +0300
Message-Id: <1285669504-21742-1-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285665597-31547-1-git-send-email-luciano.coelho@nokia.com>
References: <1285665597-31547-1-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285665597-31547-1-git-send-email-luciano.coelho@nokia.com>
References: <1285665597-31547-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are integrating wl1271 commits via a new git tree now and wl1271
development should be made on top of the new tree.

Update the repository url accordingly.

Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
In v2 I have added the missing "git " in front of the URL.  Thanks Joe Perches
for pointing out.  I also fixed John's email address.

 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6cb1c75..529bfee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6321,7 +6321,7 @@ WL1271 WIRELESS DRIVER
 M:	Luciano Coelho <luciano.coelho@nokia.com>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git
 S:	Maintained
 F:	drivers/net/wireless/wl12xx/wl1271*
 F:	include/linux/wl12xx.h
-- 
1.6.3.3

