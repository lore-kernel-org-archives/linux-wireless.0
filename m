Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14354 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753593AbaBSNBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 08:01:39 -0500
Date: Wed, 19 Feb 2014 18:17:41 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 0/3 v2] Enable ACS Support
Message-ID: <20140219124740.GA5341@markyou.marvell.com> (sfid-20140219_140142_643051_FCD1EB5C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With these patches, mwl8k will able to use
automatic channel selection feature from Hostapd.

Yogesh Ashok Powar (3):
  mwl8k: Adding support to access BBP registers
  mwl8k: Implement sw_scan start/stop cbs
  mwl8k: Adding support to gather survey per channel

 drivers/net/wireless/mwl8k.c | 195 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 189 insertions(+), 6 deletions(-)

-- 
1.8.3.4

