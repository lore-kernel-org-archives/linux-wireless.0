Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54861 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755887AbcILN0B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 09:26:01 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8CDQ0d9008444
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 06:26:00 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 25cfhnxwky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 06:25:59 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 0/2] mwifiex: usb8997 chipset support
Date: Mon, 12 Sep 2016 18:55:26 +0530
Message-ID: <1473686728-8101-1-git-send-email-akarwar@marvell.com> (sfid-20160912_152604_997323_D78F5F01)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series includes changes needed to support Marvell usb8997
chipset.

Ganapathi Bhat (2):
  mwifiex: Command 7 handling for USB chipsets
  mwifiex: firmware name correction for usb8997 chipset

 drivers/net/wireless/marvell/mwifiex/usb.c | 4 ++++
 drivers/net/wireless/marvell/mwifiex/usb.h | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

-- 
1.9.1
