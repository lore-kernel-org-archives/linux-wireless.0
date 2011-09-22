Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7986 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab1IVXBR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 19:01:17 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/12] MAINTAINERS: update iwlwifi
Date: Thu, 22 Sep 2011 15:14:49 -0700
Message-Id: <1316729700-1770-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110923_010145_301982_557C9557)
In-Reply-To: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change to iwlwifi.git instead of iwlwifi-2.6.git
iwlwifi-2.6.git still works for backward compatibility

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1789ce2..a31c614 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3413,7 +3413,7 @@ M:	Wey-Yi Guy <wey-yi.w.guy@intel.com>
 M:	Intel Linux Wireless <ilw@linux.intel.com>
 L:	linux-wireless@vger.kernel.org
 W:	http://intellinuxwireless.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git
 S:	Supported
 F:	drivers/net/wireless/iwlwifi/
 
-- 
1.7.0.4

