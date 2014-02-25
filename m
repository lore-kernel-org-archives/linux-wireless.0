Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42530 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752783AbaBYMZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 07:25:38 -0500
Date: Tue, 25 Feb 2014 17:41:39 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 0/3 v3] Enable ACS Support
Message-ID: <20140225121139.GA5638@markyou.marvell.com> (sfid-20140225_132546_163759_5A2A99D7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With these patches, Mwl8k will able to use
automatic channel selection feature from Hostapd.

Yogesh Ashok Powar (3):
  mwl8k: Adding support to access BBP registers
  mwl8k: Implement sw_scan start/stop cbs
  mwl8k: Adding support to gather survey per channel

 drivers/net/wireless/mwl8k.c | 197 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 191 insertions(+), 6 deletions(-)

-- 
1.8.3.4

