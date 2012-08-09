Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39533 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab2HIMwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 08:52:34 -0400
Received: by eeil10 with SMTP id l10so146631eei.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 05:52:30 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] compat: Drop glibc 2.14 warning
Date: Thu,  9 Aug 2012 15:52:23 +0300
Message-Id: <1344516743-3784-1-git-send-email-ozancag@gmail.com> (sfid-20120809_145236_909058_1DF773D2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is not the case anymore as we rebuild the binaries.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 bin/get-compat-kernels | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/bin/get-compat-kernels b/bin/get-compat-kernels
index 4107828..2003cd3 100755
--- a/bin/get-compat-kernels
+++ b/bin/get-compat-kernels
@@ -215,9 +215,6 @@ echo -e "The download payload is about ${YELLOW}~ $((${SPACE_PER_KERNEL_DEB} * $
 echo -e "it will stash kernel header files under ${BLUE}$KSRC_PREFIX/usr/src/${NORMAL}"
 echo -e "and ${BLUE}$KSRC_PREFIX/lib/modules/${NORMAL} and consume about ~ ${YELLOW}$((${NUM_KERNELS} * ${SPACE_PER_KERNEL})) ${RED}MiB${NORMAL} of space."
 echo -e ""
-echo -e "Note: you will need ${CYAN}libc${NORMAL} > ${GREEN}2.14${NORMAL} otherwise compilation may"
-echo -e "fail with Linux ${CYAN}3.4.4${NORMAL}"
-echo -e ""
 echo -e "The kernel headers used are from ${PURPLE}${UNDERLINE}Vanilla${NORMAL} kernels"
 echo -e "from the Ubuntu mainline / vanilla kernel PPA and are extracted"
 echo -e "using ${GREEN}ar${NORMAL} and ${GREEN}tar${NORMAL}:"
-- 
1.7.11.2

