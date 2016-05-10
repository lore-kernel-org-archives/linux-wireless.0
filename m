Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40834 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751496AbcEJUap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:30:45 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:37 +0300
Message-Id: <1462910797-20303-41-git-send-email-luca@coelho.fi> (sfid-20160510_223052_493363_7E999B95)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 41/41] MAINTAINERS: add myself as co-maintainer of the iwlwifi driver
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

I'm starting to take a more active role in the iwlwifi driver
maintainership.

Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4851f02..31983f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5831,6 +5831,7 @@ F:	drivers/net/wireless/intel/iwlegacy/
 INTEL WIRELESS WIFI LINK (iwlwifi)
 M:	Johannes Berg <johannes.berg@intel.com>
 M:	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
+M:	Luca Coelho <luciano.coelho@intel.com>
 M:	Intel Linux Wireless <linuxwifi@intel.com>
 L:	linux-wireless@vger.kernel.org
 W:	http://intellinuxwireless.org
-- 
2.8.1

