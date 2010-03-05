Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60475 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab0CEU6d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 15:58:33 -0500
Subject: [PATCH] compat: define KEY_RFKILL, which appeared in Linux 2.6.33
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Fri, 05 Mar 2010 15:58:25 -0500
Message-ID: <20100305205825.2631.44019.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is used in net/rfkill/input.c

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 include/linux/compat-2.6.33.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 9559f21..70e5f98 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -49,6 +49,8 @@ static inline void compat_release_firmware(const struct firmware *fw)
 }
 #endif
 
+#define KEY_RFKILL		247	/* Key that controls all radios */
+
 #define IFF_DONT_BRIDGE 0x800		/* disallow bridging this ether dev */
 /* source: include/linux/if.h */
 
