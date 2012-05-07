Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:61541 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106Ab2EGKcn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:32:43 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	H Hartley Sweeten <hartleys@visionengravers.com>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 14/20] NFC: Include nci_core.h to nci/lib.c
Date: Mon,  7 May 2012 12:31:25 +0200
Message-Id: <1336386691-24840-15-git-send-email-sameo@linux.intel.com> (sfid-20120507_123246_278417_2EA4C19B)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: H Hartley Sweeten <hartleys@visionengravers.com>

Include the header to pickup the exported symbol prototype.

Quites the sparse warning:

warning: symbol 'nci_to_errno' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/nci/lib.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/nfc/nci/lib.c b/net/nfc/nci/lib.c
index 6a63e5e..6b7fd26 100644
--- a/net/nfc/nci/lib.c
+++ b/net/nfc/nci/lib.c
@@ -31,6 +31,7 @@
 #include <linux/errno.h>
 
 #include <net/nfc/nci.h>
+#include <net/nfc/nci_core.h>
 
 /* NCI status codes to Unix errno mapping */
 int nci_to_errno(__u8 code)
-- 
1.7.9.1

