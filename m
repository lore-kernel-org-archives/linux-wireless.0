Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42483 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab1DKN4U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 09:56:20 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: mcgrof@gmail.com, lrodriguez@atheros.com, hauke@hauke-m.de
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [compat 1/1] compat: add license and other module params to kfifo
Date: Mon, 11 Apr 2011 16:56:15 +0300
Message-Id: <1302530175-24451-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The module taints the kernel if the license is not specified

Add also module description

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 compat/kfifo.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/compat/kfifo.c b/compat/kfifo.c
index 01a0700..7890662 100644
--- a/compat/kfifo.c
+++ b/compat/kfifo.c
@@ -27,6 +27,8 @@
 #include <linux/uaccess.h>
 #include <linux/kfifo.h>
 
+MODULE_DESCRIPTION("kfifo backport");
+MODULE_LICENSE("GPL");
 /*
  * internal helper to calculate the unused elements in a fifo
  */
-- 
1.7.4.2

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

