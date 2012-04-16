Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26223 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab2DPTHt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 15:07:49 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1] MAINTAINERS: Add maintainer for iwlwifi
Date: Mon, 16 Apr 2012 12:03:35 -0700
Message-Id: <1334603015-11991-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120416_210752_452898_BF5BA179)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add Johannes Berg as the primary maintainer for iwlwifi driver

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index dbfb6b2..b6205e3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3592,6 +3592,7 @@ S:	Supported
 F:	drivers/net/wireless/iwlegacy/
 
 INTEL WIRELESS WIFI LINK (iwlwifi)
+M:	Johannes Berg <johannes.berg@intel.com>
 M:	Wey-Yi Guy <wey-yi.w.guy@intel.com>
 M:	Intel Linux Wireless <ilw@linux.intel.com>
 L:	linux-wireless@vger.kernel.org
-- 
1.7.0.4

