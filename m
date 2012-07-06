Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:34624 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab2GFT7j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:59:39 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 16/33] NFC: Add modules alias for NFC sockets
Date: Fri,  6 Jul 2012 22:09:36 +0200
Message-Id: <1341605393-32056-17-git-send-email-sameo@linux.intel.com> (sfid-20120706_220535_502638_3643CF0E)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index 00105e7..8382fbc 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -924,3 +924,4 @@ MODULE_AUTHOR("Lauro Ramos Venancio <lauro.venancio@openbossa.org>");
 MODULE_DESCRIPTION("NFC Core ver " VERSION);
 MODULE_VERSION(VERSION);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_NETPROTO(PF_NFC);
-- 
1.7.10

