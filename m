Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48230 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbbFXFwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2015 01:52:54 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5O5nnac010632
	for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2015 22:52:53 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0a-0016f401.pphosted.com with ESMTP id 1v7d4ssgnk-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2015 22:52:53 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <nishants@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>
Subject: [PATCH] MAINTAINERS: update for mwifiex driver maintainers
Date: Wed, 24 Jun 2015 16:52:21 +0530
Message-ID: <1435144941-2441-1-git-send-email-patila@marvell.com> (sfid-20150624_075258_839561_524F7472)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amit & Nishant would be taking care of maintaining mwifiex driver here
onwards on account of organizational changes.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Frank Huang <frankh@marvell.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3a4b7cb..a2a6763 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6270,7 +6270,7 @@ F:	drivers/net/ethernet/marvell/mvneta.*
 
 MARVELL MWIFIEX WIRELESS DRIVER
 M:	Amitkumar Karwar <akarwar@marvell.com>
-M:	Avinash Patil <patila@marvell.com>
+M:	Nishant Sarmukadam <nishants@marvell.com>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/mwifiex/
-- 
1.8.1.4

