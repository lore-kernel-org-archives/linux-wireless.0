Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3465 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309AbaG3U5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2014 16:57:43 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] MAINTAINERS: update for mwifiex driver maintainers
Date: Wed, 30 Jul 2014 13:57:16 -0700
Message-ID: <1406753836-16000-1-git-send-email-bzhao@marvell.com> (sfid-20140730_225747_038566_9683995D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar and Avinash are taking care of mwifiex driver as the
maintainers now due to organizational change.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 07a5930..966318c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5706,7 +5706,8 @@ S:	Maintained
 F:	drivers/net/ethernet/marvell/mvneta.*
 
 MARVELL MWIFIEX WIRELESS DRIVER
-M:	Bing Zhao <bzhao@marvell.com>
+M:	Amitkumar Karwar <akarwar@marvell.com>
+M:	Avinash Patil <patila@marvell.com>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/mwifiex/
-- 
1.8.2.3

