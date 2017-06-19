Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:63280 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753775AbdFSKJY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 06:09:24 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 13/13] MAINTAINERS: Remove non-existing NFC platform data files
Date: Mon, 19 Jun 2017 13:08:58 +0300
Message-Id: <20170619100858.2655-14-andriy.shevchenko@linux.intel.com> (sfid-20170619_120929_156604_D3977A08)
In-Reply-To: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com>
References: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are no longer platform data files for NFC drivers.
Remove it from MAINTAINERS data base.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6f2d96313230..6b6079ad91f4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9175,8 +9175,6 @@ F:	include/uapi/linux/nfc.h
 F:	drivers/nfc/
 F:	include/linux/platform_data/nfcmrvl.h
 F:	include/linux/platform_data/nxp-nci.h
-F:	include/linux/platform_data/pn544.h
-F:	include/linux/platform_data/st21nfca.h
 F:	Documentation/devicetree/bindings/net/nfc/
 
 NFS, SUNRPC, AND LOCKD CLIENTS
-- 
2.11.0
