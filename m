Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab1CYRAT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 13:00:19 -0400
Date: Fri, 25 Mar 2011 17:59:39 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: [PATCH 01/12 v2] iwlegacy: MAINTAINERS
Message-ID: <20110325165939.GD2165@redhat.com>
References: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
 <1301062456-17249-2-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1301062456-17249-2-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add iwlegacy driver to MAINTAINERS.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 749f9cd..547cf39 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3381,6 +3381,12 @@ F:	Documentation/wimax/README.i2400m
 F:	drivers/net/wimax/i2400m/
 F:	include/linux/wimax/i2400m.h
 
+INTEL WIRELESS 3945ABG/BG, 4965AGN (iwlegacy)
+M:	Stanislaw Gruszka <sgruszka@redhat.com>
+L:	linux-wireless@vger.kernel.org
+S:	Supported
+F:	drivers/net/wireless/iwlegacy/
+
 INTEL WIRELESS WIFI LINK (iwlwifi)
 M:	Wey-Yi Guy <wey-yi.w.guy@intel.com>
 M:	Intel Linux Wireless <ilw@linux.intel.com>
-- 
1.7.1

