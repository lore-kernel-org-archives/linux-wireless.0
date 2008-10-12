Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:33772 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbYJLJXe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Oct 2008 05:23:34 -0400
Received: by ti-out-0910.google.com with SMTP id b6so620914tic.23
        for <linux-wireless@vger.kernel.org>; Sun, 12 Oct 2008 02:23:33 -0700 (PDT)
Date: Sun, 12 Oct 2008 17:23:27 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: linville@tuxdriver.com
Subject: wireless: remove duplicated #include
Cc: linux-wireless@vger.kernel.org
Message-Id: <20081012171950.F6D8.WEIYI.HUANG@gmail.com> (sfid-20081012_112341_868535_821FCEBB)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed duplicated include <linux/list.h> in 
net/wireless/core.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5cadbeb..24fdd4c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -13,7 +13,6 @@
 #include <linux/debugfs.h>
 #include <linux/notifier.h>
 #include <linux/device.h>
-#include <linux/list.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
 #include <net/wireless.h>

