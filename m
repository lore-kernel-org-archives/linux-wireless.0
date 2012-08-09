Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54162 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab2HISC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 14:02:29 -0400
Received: by wibhq12 with SMTP id hq12so550389wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 11:02:28 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 09/13] compat-wireless: Fix cmdline parameter's name
Date: Thu,  9 Aug 2012 21:01:28 +0300
Message-Id: <1344535292-4451-10-git-send-email-ozancag@gmail.com> (sfid-20120809_200252_006876_3181A99A)
In-Reply-To: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
References: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correct one is network not net.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 scripts/admin-update.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 555b61b..b5dbc4e 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -245,7 +245,7 @@ if [ $# -ge 1 ]; then
 				REFRESH="y"
 				shift
 				;;
-			"net")
+			"network")
 				ENABLE_NETWORK=1
 				shift
 				;;
-- 
1.7.11.2

