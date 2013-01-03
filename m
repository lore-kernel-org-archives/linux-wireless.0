Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:32842 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752947Ab3ACH6Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 02:58:25 -0500
Date: Thu, 3 Jan 2013 13:22:18 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 0/5] mwl8k: Support additional AMPDU streams
Message-ID: <20130103075214.GA20164@markyou.marvell.com> (sfid-20130103_085829_623578_2B81F95D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

a. Add support for additional ampdu streams 
b. Handle corresponding watchdog events to destroy ampdu streams
c. bump the fw API version

Yogesh Ashok Powar (5):
  mwl8k: Enable support to support additional ampdu streams
  mwl8k: changing mwl8k_destroy_ba prototype
  mwl8k: Handle Watchdog events for the new ampdu streams
  mwl8k: Handle watchdog event with highest prioriry
  mwl8k: bump firmware API to 3

 drivers/net/wireless/mwl8k.c | 110 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 87 insertions(+), 23 deletions(-)

-- 
1.8.0.3

