Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:21250 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab1HCFDe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 01:03:34 -0400
Subject: [PATCH 1/3] compat: remove stray #endif from compat-2.6.23.c
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 03 Aug 2011 01:03:33 -0400
Message-ID: <20110803050333.10364.78012.stgit@mj.roinet.com> (sfid-20110803_070337_671492_F8BE26D2)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 compat/compat-2.6.23.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/compat/compat-2.6.23.c b/compat/compat-2.6.23.c
index 67d0075..d31cfb4 100644
--- a/compat/compat-2.6.23.c
+++ b/compat/compat-2.6.23.c
@@ -235,5 +235,4 @@ int pci_try_set_mwi(struct pci_dev *dev)
 	return rc;
 }
 EXPORT_SYMBOL(pci_try_set_mwi);
-#endif
 
