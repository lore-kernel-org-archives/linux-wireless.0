Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34840 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbaHKKUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 06:20:46 -0400
Date: Mon, 11 Aug 2014 13:14:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: MAINTAINTERS: The NFC list is subscribers-only
Message-ID: <20140811101138.GA24837@mwanda> (sfid-20140811_122049_749207_14845CB7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not moderated, it's subscribers-only.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c3346aa..5b6992e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6326,7 +6326,7 @@ M:	Lauro Ramos Venancio <lauro.venancio@openbossa.org>
 M:	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
 M:	Samuel Ortiz <sameo@linux.intel.com>
 L:	linux-wireless@vger.kernel.org
-L:	linux-nfc@lists.01.org (moderated for non-subscribers)
+L:	linux-nfc@lists.01.org (subscribers-only)
 S:	Supported
 F:	net/nfc/
 F:	include/net/nfc/
