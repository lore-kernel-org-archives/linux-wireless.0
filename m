Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40373 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2GVKjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jul 2012 06:39:19 -0400
Received: by weyx8 with SMTP id x8so3622788wey.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jul 2012 03:39:18 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat: Add 3.5 to the list of kernels
Date: Sun, 22 Jul 2012 13:39:11 +0300
Message-Id: <1342953551-19505-1-git-send-email-ozancag@gmail.com> (sfid-20120722_123959_447682_2A8A21BB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add 3.5 to the list of kernels in bin/get-compat-kernels.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 bin/get-compat-kernels |    1 +
 1 file changed, 1 insertion(+)

diff --git a/bin/get-compat-kernels b/bin/get-compat-kernels
index 6d9d9fe..4479d0f 100755
--- a/bin/get-compat-kernels
+++ b/bin/get-compat-kernels
@@ -56,6 +56,7 @@ KERNELS="$KERNELS ${KPATH}/v3.1.10-precise/linux-headers-3.1.10-030110_3.1.10-03
 KERNELS="$KERNELS ${KPATH}/v3.2.2-precise/linux-headers-3.2.2-030202_3.2.2-030202.201201252035_all.deb"
 KERNELS="$KERNELS ${KPATH}/v3.3.7-precise/linux-headers-3.3.7-030307_3.3.7-030307.201205211535_all.deb"
 KERNELS="$KERNELS ${KPATH}/v3.4.4-quantal/linux-headers-3.4.4-030404_3.4.4-030404.201206221555_all.deb"
+KERNELS="$KERNELS ${KPATH}/v3.5-quantal/linux-headers-3.5.0-030500_3.5.0-030500.201207211835_all.deb"
 
 # Number of kernels
 NUM_KERNELS=$(echo $KERNELS | wc -w)
-- 
1.7.10.4

