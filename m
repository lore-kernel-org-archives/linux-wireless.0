Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:50927 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296Ab2JXSpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 14:45:47 -0400
From: Marcel Holtmann <marcel@holtmann.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] MAINTAINERS: Add reference to pn544.h platform data header
Date: Wed, 24 Oct 2012 11:45:38 -0700
Message-Id: <1351104338-5263-1-git-send-email-marcel@holtmann.org> (sfid-20121024_204551_694359_14EF35B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The platform data header for PN544 based NFC devices should
also be mentioned here.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5655bcc..a6e190f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5083,6 +5083,7 @@ F:	net/nfc/
 F:	include/linux/nfc.h
 F:	include/net/nfc/
 F:	drivers/nfc/
+F:	include/linux/platform_data/pn544.h
 
 NFS, SUNRPC, AND LOCKD CLIENTS
 M:	Trond Myklebust <Trond.Myklebust@netapp.com>
-- 
1.7.11.7

