Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:34692 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969Ab3CWEtR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 00:49:17 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/3] mwifiex PCIe power save updates
Date: Fri, 22 Mar 2013 21:49:04 -0700
Message-ID: <1364014147-13986-1-git-send-email-bzhao@marvell.com> (sfid-20130323_054928_276403_7EE551F4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches update PCIe power save handling

Avinash Patil (3):
  mwifiex: do not enable PCIe interrupt in Power Save sleep state
  mwifiex: avoid waking up device in awake state
  mwifiex: use fw_status register to wake up PCIe card

 drivers/net/wireless/mwifiex/pcie.c |   47 ++++++++++++++++++++++------------
 1 files changed, 30 insertions(+), 17 deletions(-)

