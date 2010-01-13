Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54472 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab0AMV3N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 16:29:13 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: fix constant name
Date: Wed, 13 Jan 2010 22:29:05 +0100
Message-Id: <1263418145-30380-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1263418145-30380-1-git-send-email-hauke@hauke-m.de>
References: <1263418145-30380-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/03-rfkill.patch |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/patches/03-rfkill.patch b/patches/03-rfkill.patch
index ac44545..8df6fde 100644
--- a/patches/03-rfkill.patch
+++ b/patches/03-rfkill.patch
@@ -179,7 +179,7 @@ This would do the policing from within mac80211.
  };
  
 -#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
-+#if defined(CONFIG_RFKILL_BACKPORT) || defined(CONFIG_RFKILL_MODULE_BACKPORT)
++#if defined(CONFIG_RFKILL_BACKPORT) || defined(CONFIG_RFKILL_BACKPORT_MODULE)
  /**
   * rfkill_alloc - allocate rfkill structure
   * @name: name of the struct -- the string is not copied internally
-- 
1.6.3.3

