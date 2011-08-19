Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34065 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab1HSTKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 15:10:07 -0400
Received: by yxj19 with SMTP id 19so2416352yxj.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Aug 2011 12:10:06 -0700 (PDT)
From: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: [PATCH] MAINTAINERS: Add NFC subsystem entry
Date: Fri, 19 Aug 2011 16:09:49 -0300
Message-Id: <1313780989-17494-1-git-send-email-aloisio.almeida@openbossa.org> (sfid-20110819_211011_149270_EC5C2FA1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update MAINTAINERS with NFC subsystem and drivers entry.

Signed-off-by: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
---
 MAINTAINERS |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d2e79d..4771368 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4492,6 +4492,17 @@ W:	http://www.qlogic.com
 S:	Supported
 F:	drivers/net/netxen/
 
+NFC SUBSYSTEM
+M:	Lauro Ramos Venancio <lauro.venancio@openbossa.org>
+M:	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
+M:	Samuel Ortiz <sameo@linux.intel.com>
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+F:	net/nfc/
+F:	include/linux/nfc.h
+F:	include/net/nfc.h
+F:	drivers/nfc/
+
 NFS, SUNRPC, AND LOCKD CLIENTS
 M:	Trond Myklebust <Trond.Myklebust@netapp.com>
 L:	linux-nfs@vger.kernel.org
-- 
1.7.5.4

