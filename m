Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:12954 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865Ab1GZPhT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 11:37:19 -0400
Subject: [PATCH 2/2] b43legacy: remove asm/atomic.h includes as suggested by
 checkpatch.pl
To: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 26 Jul 2011 11:36:56 -0400
Message-ID: <20110726153655.24611.76833.stgit@mj.roinet.com> (sfid-20110726_173803_661600_70C0C421)
In-Reply-To: <20110726153648.24611.49190.stgit@mj.roinet.com>
References: <20110726153648.24611.49190.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Including linux/atomic.h doesn't appear to be necessary.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 0 files changed, 0 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/b43legacy.h b/drivers/net/wireless/b43legacy/b43legacy.h
index 17a130d..71159aa 100644
--- a/drivers/net/wireless/b43legacy/b43legacy.h
+++ b/drivers/net/wireless/b43legacy/b43legacy.h
@@ -8,7 +8,6 @@
 #include <linux/stringify.h>
 #include <linux/netdevice.h>
 #include <linux/pci.h>
-#include <asm/atomic.h>
 #include <linux/io.h>
 
 #include <linux/ssb/ssb.h>
diff --git a/drivers/net/wireless/b43legacy/dma.h b/drivers/net/wireless/b43legacy/dma.h
index 04121ff..7ed84b9 100644
--- a/drivers/net/wireless/b43legacy/dma.h
+++ b/drivers/net/wireless/b43legacy/dma.h
@@ -5,7 +5,6 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/linkage.h>
-#include <asm/atomic.h>
 
 #include "b43legacy.h"
 
