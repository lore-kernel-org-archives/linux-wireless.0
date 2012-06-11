Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40197 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2FKVcF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 17:32:05 -0400
Received: by weyu7 with SMTP id u7so2395970wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 14:32:03 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] bin/get-compat-kernels: Update 3.3 and add 3.4 kernels
Date: Tue, 12 Jun 2012 00:31:55 +0300
Message-Id: <1339450315-2136-1-git-send-email-ozancag@gmail.com> (sfid-20120611_233209_093834_E4C050F2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ubdate 3.3 kernel to the latest one and add 3.4 kernel.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 bin/get-compat-kernels |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/bin/get-compat-kernels b/bin/get-compat-kernels
index 7a253c2..e6c586d 100755
--- a/bin/get-compat-kernels
+++ b/bin/get-compat-kernels
@@ -108,9 +108,13 @@ function get_ubuntu_kernels() {
 	KERNELS="$KERNELS ${KPATH}/v3.2.2-precise/linux-headers-3.2.2-030202-generic_3.2.2-030202.201201252035_${TARGET}.deb"
 	KERNELS="$KERNELS ${KPATH}/v3.2.2-precise/linux-image-3.2.2-030202-generic_3.2.2-030202.201201252035_${TARGET}.deb"
 
-	KERNELS="$KERNELS ${KPATH}/v3.3-rc2-precise/linux-headers-3.3.0-030300rc2_3.3.0-030300rc2.201201311735_all.deb"
-	KERNELS="$KERNELS ${KPATH}/v3.3-rc2-precise/linux-headers-3.3.0-030300rc2-generic_3.3.0-030300rc2.201201311735_${TARGET}.deb"
-	KERNELS="$KERNELS ${KPATH}/v3.3-rc2-precise/linux-image-3.3.0-030300rc2-generic_3.3.0-030300rc2.201201311735_${TARGET}.deb"
+	KERNELS="$KERNELS ${KPATH}/v3.3.7-precise/linux-headers-3.3.7-030307_3.3.7-030307.201205211535_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v3.3.7-precise/linux-headers-3.3.7-030307-generic_3.3.7-030307.201205211535_${TARGET}.deb"
+	KERNELS="$KERNELS ${KPATH}/v3.3.7-precise/linux-image-3.3.7-030307-generic_3.3.7-030307.201205211535_${TARGET}.deb"
+
+	KERNELS="$KERNELS ${KPATH}/v3.4-precise/linux-headers-3.4.0-030400_3.4.0-030400.201205210521_all.deb"
+	KERNELS="$KERNELS ${KPATH}/v3.4-precise/linux-headers-3.4.0-030400-generic_3.4.0-030400.201205210521_${TARGET}.deb"
+	KERNELS="$KERNELS ${KPATH}/v3.4-precise/linux-image-3.4.0-030400-generic_3.4.0-030400.201205210521_${TARGET}.deb"
 
 	for i in $KERNELS; do
 		FILE=$(basename $i)
-- 
1.7.10.2

