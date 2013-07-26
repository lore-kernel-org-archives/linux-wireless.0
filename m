Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58117 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029Ab3GZI3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 29/30] iwlwifi: list Emmanuel in maintainers file
Date: Fri, 26 Jul 2013 10:28:46 +0200
Message-Id: <1374827327-3464-30-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103017_660094_62262845)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Wey-Yi has moved on a while ago, but we forgot to update the
maintainers file. Since Emmanuel is de facto maintaining the
driver along with myself now, list him instead.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bf61e04..d44a5e8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4362,7 +4362,7 @@ F:	drivers/net/wireless/iwlegacy/
 
 INTEL WIRELESS WIFI LINK (iwlwifi)
 M:	Johannes Berg <johannes.berg@intel.com>
-M:	Wey-Yi Guy <wey-yi.w.guy@intel.com>
+M:	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
 M:	Intel Linux Wireless <ilw@linux.intel.com>
 L:	linux-wireless@vger.kernel.org
 W:	http://intellinuxwireless.org
-- 
1.8.0

