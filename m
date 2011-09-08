Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:52805 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756850Ab1IIAXb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 20:23:31 -0400
Message-ID: <4E68F882.8000705@xenotime.net> (sfid-20110909_022345_341097_AE842D97)
Date: Thu, 08 Sep 2011 10:16:50 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] wireless: fix kernel-doc warning in net/cfg80211.h
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kernel-doc warning in net/cfg80211.h:

Warning(include/net/cfg80211.h:1884): No description found for parameter 'registered'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 include/net/cfg80211.h |    2 ++
 1 file changed, 2 insertions(+)

--- lnx-31-rc5.orig/include/net/cfg80211.h
+++ lnx-31-rc5/include/net/cfg80211.h
@@ -1744,6 +1744,8 @@ struct wiphy_wowlan_support {
  *	by default for perm_addr. In this case, the mask should be set to
  *	all-zeroes. In this case it is assumed that the device can handle
  *	the same number of arbitrary MAC addresses.
+ * @registered: protects ->resume and ->suspend sysfs callbacks against
+ *	unregister hardware
  * @debugfsdir: debugfs directory used for this wiphy, will be renamed
  *	automatically on wiphy renames
  * @dev: (virtual) struct device for this wiphy
