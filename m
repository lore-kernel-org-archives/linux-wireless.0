Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:40361 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754036AbXFKTnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 15:43:35 -0400
Message-ID: <466DA5D3.3050401@linux.intel.com>
Date: Mon, 11 Jun 2007 12:43:15 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] Add MAINTAINERS entry for iwlwifi
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Cc: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: James Ketrenos <jketreno@linux.intel.com>
---
 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f3b5a39..61c0f20 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1972,6 +1972,16 @@ L:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
 W:	http://ipw2200.sourceforge.net
 S:	Supported
 
+INTEL WIRELESS WIFI LINK (iwlwifi)
+P:	Zhu Yi
+M:	yi.zhu@intel.com
+L:	linux-wireless@vger.kernel.org
+L:	ipw3945-devel@lists.sourceforge.net
+L:	http://lists.sourceforge.net/mailman/listinfo/ipw3945-devel
+W:	http://intellinuxwireless.org
+T:	git git://intellinuxwireless.org/repos/iwlwifi
+S:	Supported
+
 IOC3 DRIVER
 P:	Ralf Baechle
 M:	ralf@linux-mips.org
-- 
1.5.2
