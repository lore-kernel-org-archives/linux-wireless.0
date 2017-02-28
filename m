Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42284 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752437AbdB1Nxi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Feb 2017 08:53:38 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1SDOfT2003655
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2017 05:24:56 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 28uaamfs6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2017 05:24:56 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] MAINTAINERS: update for mwifiex driver maintainers
Date: Tue, 28 Feb 2017 18:54:31 +0530
Message-ID: <1488288271-10731-1-git-send-email-akarwar@marvell.com> (sfid-20170228_145348_342272_68CF1340)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi & Xinming are starting to take a more active role in the
mwifiex driver maintainership here onwards on account of organizational
changes.

CC: Xinming Hu <huxm@marvell.com>
CC: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d8f71f2..9252718 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7772,6 +7772,8 @@ F:	drivers/net/ethernet/marvell/mvneta.*
 MARVELL MWIFIEX WIRELESS DRIVER
 M:	Amitkumar Karwar <akarwar@marvell.com>
 M:	Nishant Sarmukadam <nishants@marvell.com>
+M:	Ganapathi Bhat <gbhat@marvell.com>
+M:	Xinming Hu <huxm@marvell.com>
 L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/net/wireless/marvell/mwifiex/
-- 
1.9.1
