Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49530 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab0KET1S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 15:27:18 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat: remove unnecessary ifdefs and empty file
Date: Fri,  5 Nov 2010 20:27:03 +0100
Message-Id: <1288985223-30264-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1288985223-30264-1-git-send-email-hauke@hauke-m.de>
References: <1288985223-30264-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Makefile only builds the needed compat-2.6.XX.c files and not all,
so the ifdefs are not needed.

compat-2.6.30.c did not had any real content so remove it.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/Makefile        |    1 -
 compat/compat-2.6.14.c |    4 ----
 compat/compat-2.6.18.c |    4 ----
 compat/compat-2.6.19.c |    4 ----
 compat/compat-2.6.21.c |    4 ----
 compat/compat-2.6.22.c |    4 ----
 compat/compat-2.6.23.c |    5 -----
 compat/compat-2.6.24.c |    6 ------
 compat/compat-2.6.25.c |    5 -----
 compat/compat-2.6.26.c |    6 ------
 compat/compat-2.6.27.c |    5 -----
 compat/compat-2.6.28.c |    4 ----
 compat/compat-2.6.29.c |    6 ------
 compat/compat-2.6.30.c |   18 ------------------
 compat/compat-2.6.32.c |    5 -----
 compat/compat-2.6.33.c |    5 -----
 compat/compat-2.6.35.c |    3 ---
 compat/compat-2.6.36.c |    4 ----
 compat/compat-2.6.37.c |    4 ----
 19 files changed, 0 insertions(+), 97 deletions(-)
 delete mode 100644 compat/compat-2.6.30.c

diff --git a/compat/Makefile b/compat/Makefile
index c15a8f3..46049af 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -22,7 +22,6 @@ compat-$(CONFIG_COMPAT_KERNEL_26) += compat-2.6.26.o
 compat-$(CONFIG_COMPAT_KERNEL_27) += compat-2.6.27.o
 compat-$(CONFIG_COMPAT_KERNEL_28) += compat-2.6.28.o
 compat-$(CONFIG_COMPAT_KERNEL_29) += compat-2.6.29.o
-compat-$(CONFIG_COMPAT_KERNEL_30) += compat-2.6.30.o
 compat-$(CONFIG_COMPAT_KERNEL_32) += compat-2.6.32.o
 compat-$(CONFIG_COMPAT_KERNEL_33) += compat-2.6.33.o
 compat-$(CONFIG_COMPAT_KERNEL_35) += compat-2.6.35.o
diff --git a/compat/compat-2.6.14.c b/compat/compat-2.6.14.c
index e0af181..3de847d 100644
--- a/compat/compat-2.6.14.c
+++ b/compat/compat-2.6.14.c
@@ -10,9 +10,5 @@
 
 #include <net/compat.h>
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14))
-
 /* 2.6.14 compat code goes here */
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14) */
-
diff --git a/compat/compat-2.6.18.c b/compat/compat-2.6.18.c
index c7fb2e4..c7961ee 100644
--- a/compat/compat-2.6.18.c
+++ b/compat/compat-2.6.18.c
@@ -10,9 +10,5 @@
 
 #include <net/compat.h>
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18))
-
 /* 2.6.18 compat code goes here */
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18) */
-
diff --git a/compat/compat-2.6.19.c b/compat/compat-2.6.19.c
index fc75b64..60c3404 100644
--- a/compat/compat-2.6.19.c
+++ b/compat/compat-2.6.19.c
@@ -10,9 +10,5 @@
 
 #include <net/compat.h>
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19))
-
 /* 2.6.19 compat code goes here */
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19) */
-
diff --git a/compat/compat-2.6.21.c b/compat/compat-2.6.21.c
index e2737fb..7cf8861 100644
--- a/compat/compat-2.6.21.c
+++ b/compat/compat-2.6.21.c
@@ -10,9 +10,5 @@
 
 #include <net/compat.h>
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21))
-
 /* 2.6.21 compat code goes here */
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21) */
-
diff --git a/compat/compat-2.6.22.c b/compat/compat-2.6.22.c
index b1ff1f3..d4df7b7 100644
--- a/compat/compat-2.6.22.c
+++ b/compat/compat-2.6.22.c
@@ -10,9 +10,5 @@
 
 #include <net/compat.h>
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22))
-
 /* 2.6.22 compat code goes here */
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22) */
-
diff --git a/compat/compat-2.6.23.c b/compat/compat-2.6.23.c
index 136d949..87f2a8c 100644
--- a/compat/compat-2.6.23.c
+++ b/compat/compat-2.6.23.c
@@ -10,9 +10,6 @@
 
 #include <net/compat.h>
 
-/* All things not in 2.6.22 */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23))
-
 /* On net/core/dev.c as of 2.6.24 */
 int __dev_addr_delete(struct dev_addr_list **list, int *count,
                       void *addr, int alen, int glbl)
@@ -245,5 +242,3 @@ int pci_try_set_mwi(struct pci_dev *dev)
 EXPORT_SYMBOL(pci_try_set_mwi);
 #endif
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23)) */
-
diff --git a/compat/compat-2.6.24.c b/compat/compat-2.6.24.c
index 31a9212..a5c9c97 100644
--- a/compat/compat-2.6.24.c
+++ b/compat/compat-2.6.24.c
@@ -9,10 +9,6 @@
  */
 
 #include <net/compat.h>
-
-/* All things not in 2.6.22 and 2.6.23 */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
-
 #include <net/arp.h>
 
 /*
@@ -181,5 +177,3 @@ int compat_is_pcie(struct pci_dev *pdev)
 }
 EXPORT_SYMBOL(compat_is_pcie);
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24) */
-
diff --git a/compat/compat-2.6.25.c b/compat/compat-2.6.25.c
index 7546821..7cb996b 100644
--- a/compat/compat-2.6.25.c
+++ b/compat/compat-2.6.25.c
@@ -8,9 +8,6 @@
  * Compatibility file for Linux wireless for kernels 2.6.25.
  */
 
-/* All things not in 2.6.22, 2.6.23 and 2.6.24 */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25))
-
 #include <linux/miscdevice.h>
 
 /**
@@ -98,5 +95,3 @@ define_strict_strtox(l, long)
 EXPORT_SYMBOL(strict_strtoul);
 EXPORT_SYMBOL(strict_strtol);
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25) */
-
diff --git a/compat/compat-2.6.26.c b/compat/compat-2.6.26.c
index b9bf9e7..f471506 100644
--- a/compat/compat-2.6.26.c
+++ b/compat/compat-2.6.26.c
@@ -16,10 +16,6 @@
 
 #include <net/compat.h>
 
-/* All things not in 2.6.25 */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,26))
-
-
 /* 2.6.24 does not have the struct kobject with a name */
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,25))
 
@@ -89,5 +85,3 @@ int dev_set_name(struct device *dev, const char *fmt, ...)
 }
 EXPORT_SYMBOL_GPL(dev_set_name);
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,26) */
-
diff --git a/compat/compat-2.6.27.c b/compat/compat-2.6.27.c
index b78d465..25bee28 100644
--- a/compat/compat-2.6.27.c
+++ b/compat/compat-2.6.27.c
@@ -9,9 +9,6 @@
  */
 
 #include <linux/compat.h>
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27))
-
 #include <linux/pci.h>
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
 #include <linux/mmc/sdio.h>
@@ -240,5 +237,3 @@ void debugfs_remove_recursive(struct dentry *dentry)
 EXPORT_SYMBOL_GPL(debugfs_remove_recursive);
 #endif /* CONFIG_DEBUG_FS */
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27) */
-
diff --git a/compat/compat-2.6.28.c b/compat/compat-2.6.28.c
index c11ba40..7a834d2 100644
--- a/compat/compat-2.6.28.c
+++ b/compat/compat-2.6.28.c
@@ -9,9 +9,6 @@
  */
 
 #include <linux/compat.h>
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28))
-
 #include <linux/usb.h>
 #include <linux/tty.h>
 #include <asm/poll.h>
@@ -442,4 +439,3 @@ int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 }
 EXPORT_SYMBOL(n_tty_ioctl_helper);
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28) */
diff --git a/compat/compat-2.6.29.c b/compat/compat-2.6.29.c
index cded3cc..14f5e90 100644
--- a/compat/compat-2.6.29.c
+++ b/compat/compat-2.6.29.c
@@ -9,9 +9,6 @@
  */
 
 #include <linux/compat.h>
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
-
 #include <linux/usb.h>
 #include <linux/etherdevice.h>
 
@@ -167,6 +164,3 @@ int init_dummy_netdev(struct net_device *dev)
 EXPORT_SYMBOL_GPL(init_dummy_netdev);
 /* Source: net/core/dev.c */
 
-
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29) */
-
diff --git a/compat/compat-2.6.30.c b/compat/compat-2.6.30.c
deleted file mode 100644
index f821918..0000000
--- a/compat/compat-2.6.30.c
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * Copyright 2007	Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Compatibility file for Linux wireless for kernels 2.6.30.
- */
-
-#include <linux/compat.h>
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
-
-/* 2.6.30 compat code goes here */
-
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30) */
-
diff --git a/compat/compat-2.6.32.c b/compat/compat-2.6.32.c
index 22c2c19..013150d 100644
--- a/compat/compat-2.6.32.c
+++ b/compat/compat-2.6.32.c
@@ -9,9 +9,6 @@
  */
 
 #include <linux/compat.h>
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32))
-
 #include <linux/netdevice.h>
 
 int __dev_addr_add(struct dev_addr_list **list, int *count,
@@ -120,5 +117,3 @@ void __dev_addr_unsync(struct dev_addr_list **to, int *to_count,
 }
 EXPORT_SYMBOL_GPL(__dev_addr_unsync);
 
-#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)) */
-
diff --git a/compat/compat-2.6.33.c b/compat/compat-2.6.33.c
index 055082e..c8e568d 100644
--- a/compat/compat-2.6.33.c
+++ b/compat/compat-2.6.33.c
@@ -9,9 +9,6 @@
  */
 
 #include <linux/compat.h>
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
-
 #include <linux/autoconf.h>
 
 #if defined(CONFIG_PCCARD) || defined(CONFIG_PCCARD_MODULE)
@@ -133,5 +130,3 @@ EXPORT_SYMBOL(pcmcia_loop_tuple);
 
 #endif /* CONFIG_PCCARD */
 
-#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)) */
-
diff --git a/compat/compat-2.6.35.c b/compat/compat-2.6.35.c
index abb08c7..44a15d6 100644
--- a/compat/compat-2.6.35.c
+++ b/compat/compat-2.6.35.c
@@ -9,8 +9,6 @@
  */
 
 #include <linux/compat.h>
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)
 #include <linux/ctype.h>
 
 /**
@@ -48,4 +46,3 @@ loff_t noop_llseek(struct file *file, loff_t offset, int origin)
 }
 EXPORT_SYMBOL(noop_llseek);
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35) */
diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
index bd9335d..5faefb4 100644
--- a/compat/compat-2.6.36.c
+++ b/compat/compat-2.6.36.c
@@ -9,9 +9,6 @@
  */
 
 #include <linux/compat.h>
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)
-
 #include <linux/usb.h>
 
 #ifdef CONFIG_COMPAT_USB_URB_THREAD_FIX
@@ -97,4 +94,3 @@ void compat_usb_scuttle_anchored_urbs(struct usb_anchor *anchor)
 EXPORT_SYMBOL_GPL(compat_usb_scuttle_anchored_urbs);
 #endif /* CONFIG_COMPAT_USB_URB_THREAD_FIX */
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36) */
diff --git a/compat/compat-2.6.37.c b/compat/compat-2.6.37.c
index d949a92..81f466f 100644
--- a/compat/compat-2.6.37.c
+++ b/compat/compat-2.6.37.c
@@ -9,9 +9,6 @@
  */
 
 #include <linux/compat.h>
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37)
-
 #include <linux/netdevice.h>
 #include <net/sock.h>
 #include <linux/nsproxy.h>
@@ -155,4 +152,3 @@ int compat_genl_unregister_family(struct genl_family *family)
 }
 EXPORT_SYMBOL(compat_genl_unregister_family);
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37) */
-- 
1.7.1

