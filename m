Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41899 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab1CYObg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 10:31:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/12] iwlegacy: MAINTAINERS
Date: Fri, 25 Mar 2011 07:14:05 -0700
Message-Id: <1301062456-17249-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add iwlegacy driver to MAINTAINERS file and mark as 'Orphan'

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 95482e9..12698b3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3322,6 +3322,16 @@ F:	Documentation/wimax/README.i2400m
 F:	drivers/net/wimax/i2400m/
 F:	include/linux/wimax/i2400m.h
 
+INTEL PRO/WIRELESS 3945ABG/BG NETWORK CONNECTION SUPPORT
+L:	linux-wireless@vger.kernel.org
+S:	Orphan
+F:	drivers/net/wireless/iwlegacy/
+
+INTEL WIRELESS WIFI 4965AGN NETWORK CONNECTION SUPPORT
+L:	linux-wireless@vger.kernel.org
+S:	Orphan
+F:	drivers/net/wireless/iwlegacy/
+
 INTEL WIRELESS WIFI LINK (iwlwifi)
 M:	Wey-Yi Guy <wey-yi.w.guy@intel.com>
 M:	Intel Linux Wireless <ilw@linux.intel.com>
-- 
1.7.0.4

