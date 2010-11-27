Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45765 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab0K0GWP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Nov 2010 01:22:15 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 9/9]include:linux Change the copyright info.
Date: Fri, 26 Nov 2010 22:21:19 -0800
Message-Id: <1290838879-11038-10-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
References: <1290838879-11038-1-git-send-email-justinmattock@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the copyright info from Sun Microsystems to Oracle since Oracle now owns them.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 include/linux/ethtool.h       |    4 ++--
 include/linux/mlx4/doorbell.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 6628a50..2d895be 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -3,11 +3,11 @@
  *
  * Copyright (C) 1998 David S. Miller (davem@redhat.com)
  * Copyright 2001 Jeff Garzik <jgarzik@pobox.com>
- * Portions Copyright 2001 Sun Microsystems (thockin@sun.com)
+ * Portions Copyright 2001 Oracle and/or its affiliates. (thockin@sun.com)
  * Portions Copyright 2002 Intel (eli.kupermann@intel.com,
  *                                christopher.leech@intel.com,
  *                                scott.feldman@intel.com)
- * Portions Copyright (C) Sun Microsystems 2008
+ * Portions Copyright (C) 2008 Oracle and/or its affiliates. 
  */
 
 #ifndef _LINUX_ETHTOOL_H
diff --git a/include/linux/mlx4/doorbell.h b/include/linux/mlx4/doorbell.h
index f31bba2..d251ee8 100644
--- a/include/linux/mlx4/doorbell.h
+++ b/include/linux/mlx4/doorbell.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004 Topspin Communications.  All rights reserved.
- * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Oracle and/or its affiliates. All rights reserved.
  * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
  *
  * This software is available to you under a choice of one of two
-- 
1.7.1

