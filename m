Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24766 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568AbcBCGIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 01:08:54 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u13651xv009235
	for <linux-wireless@vger.kernel.org>; Tue, 2 Feb 2016 22:08:53 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 20svyv7mxj-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 02 Feb 2016 22:08:53 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 0/8] mwifiex enhancements
Date: Tue, 2 Feb 2016 22:05:01 -0800
Message-ID: <1454479509-27129-1-git-send-email-akarwar@marvell.com> (sfid-20160203_070857_458818_7EA782A7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series incrementally improves existing firmware
dump code and adds firmware dump support for 8997 chipset

Amitkumar Karwar (1):
  mwifiex: increase the priority of firmware dump message

Xinming Hu (7):
  mwifiex: display right transmit packet delay
  mwifiex: process pcie io memory read failure case
  mwifiex: skip firmware dump when read_regs() fails
  mwifiex: keep original structure in decl header file
  mwifiex: use an extensible framework for firmware dump solution
  mwifiex: dynamically increase preallocated firmware dump memory size
  mwifiex: firmware dump support for w8997 chipset

 drivers/net/wireless/marvell/mwifiex/decl.h | 24 ++++++++
 drivers/net/wireless/marvell/mwifiex/main.h | 21 +------
 drivers/net/wireless/marvell/mwifiex/pcie.c | 94 +++++++++++++++++------------
 drivers/net/wireless/marvell/mwifiex/pcie.h | 33 +++++++++-
 drivers/net/wireless/marvell/mwifiex/wmm.c  |  1 +
 5 files changed, 115 insertions(+), 58 deletions(-)

-- 
1.8.1.4

