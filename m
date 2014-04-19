Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbaDSLDz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2014 07:03:55 -0400
Date: Sat, 19 Apr 2014 13:03:52 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-wireless@vger.kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] NFC: The linux-nfc list is subscribers-only
Message-ID: <20140419130352.2c305d9e@endymion.delvare> (sfid-20140419_130359_072719_E116FBBE)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the automatic reply I received when trying to send a
message to the linux-nfc list, it is not only moderated, it is
actually subscribers-only.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.15-rc1.orig/MAINTAINERS	2014-04-18 16:47:16.044614592 +0200
+++ linux-3.15-rc1/MAINTAINERS	2014-04-19 12:54:11.072671978 +0200
@@ -6197,7 +6197,7 @@ M:	Lauro Ramos Venancio <lauro.venancio@
 M:	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
 M:	Samuel Ortiz <sameo@linux.intel.com>
 L:	linux-wireless@vger.kernel.org
-L:	linux-nfc@lists.01.org (moderated for non-subscribers)
+L:	linux-nfc@lists.01.org (subscribers-only)
 S:	Supported
 F:	net/nfc/
 F:	include/net/nfc/

-- 
Jean Delvare
SUSE L3 Support
