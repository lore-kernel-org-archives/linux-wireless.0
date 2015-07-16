Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48899 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668AbbGPPJr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2015 11:09:47 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t6GF9kj9023753
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2015 08:09:46 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 1vnb4c5ecj-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2015 08:09:46 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 0/3] mwifiex p2p fixes
Date: Thu, 16 Jul 2015 08:05:20 -0700
Message-ID: <1437059123-19477-1-git-send-email-akarwar@marvell.com> (sfid-20150716_170949_994166_3016D45C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series resolves couple of issues observed during p2p
opeations.

v2: Removed redundant tag "UPSTREAM:" in patch title.

Aniket Nagarnaik (3):
  mwifiex: add bss mode TLV to extended scan command
  mwifiex: use maximum ssid length as 0xfe for p2p
  mwifiex: correct p2p and station interface counters

 drivers/net/wireless/mwifiex/cfg80211.c |  4 +++-
 drivers/net/wireless/mwifiex/fw.h       |  6 ++++++
 drivers/net/wireless/mwifiex/scan.c     | 14 ++++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

-- 
1.8.1.4

