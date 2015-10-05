Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57086 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751311AbbJEOhK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 10:37:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:35 +0300
Message-Id: <1444055820-27506-4-git-send-email-luca@coelho.fi> (sfid-20151005_163817_563207_DCF6DCC9)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 04/29] MAINTAINERS: iwlwifi: update contact email
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The ilw@linux.intel.com address is being phased out, replace
it with the new address.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 310da42..77b2728 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5541,7 +5541,7 @@ F:	drivers/net/wireless/iwlegacy/
 INTEL WIRELESS WIFI LINK (iwlwifi)
 M:	Johannes Berg <johannes.berg@intel.com>
 M:	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
-M:	Intel Linux Wireless <ilw@linux.intel.com>
+M:	Intel Linux Wireless <linuxwifi@intel.com>
 L:	linux-wireless@vger.kernel.org
 W:	http://intellinuxwireless.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git
-- 
2.5.3

