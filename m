Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41018 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932072AbcF3P3h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 11:29:37 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u5UF1xRR020794
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2016 08:02:40 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 23ssffacjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2016 08:02:40 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 0/2] mwifiex: manufacturing mode
Date: Thu, 30 Jun 2016 20:31:13 +0530
Message-ID: <1467298875-3581-1-git-send-email-akarwar@marvell.com> (sfid-20160630_172956_648797_4FE80D32)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds support for loading the driver in manufacturing
mode. It's needed to perform certain factory tests.

Amitkumar Karwar (1):
  mwifiex: add manufacturing mode support

Xinming Hu (1):
  mwifiex: add hostcmd wext ioctl support

 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 67 ++++++++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/init.c   | 22 +++++---
 drivers/net/wireless/marvell/mwifiex/main.c   | 73 +++++++++++++++++++++++++--
 drivers/net/wireless/marvell/mwifiex/main.h   | 13 ++++-
 drivers/net/wireless/marvell/mwifiex/pcie.c   |  2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c   |  2 +-
 drivers/net/wireless/marvell/mwifiex/usb.c    |  2 +-
 7 files changed, 166 insertions(+), 15 deletions(-)

-- 
1.9.1

