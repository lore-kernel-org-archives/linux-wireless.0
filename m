Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:58352 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756082Ab3BICW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 21:22:27 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 0/4] mwifiex: pcie8897 series for 3.9
Date: Fri,  8 Feb 2013 18:18:05 -0800
Message-Id: <1360376289-14861-1-git-send-email-bzhao@marvell.com> (sfid-20130209_032236_061593_63AC57DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds support for Marvell pcie8897 card.
Only basic functions are supported in this series.
Power Save, 11ac and other features will be added later.

Avinash Patil (4):
  mwifiex: store card specific data in PCI device table entry
  mwifiex: separate ring initialization and ring creation routines
  mwifiex: define generic data type for PCIe ring buffers
  mwifiex: add PCIe8897 support

 drivers/net/wireless/mwifiex/Kconfig |    4 +-
 drivers/net/wireless/mwifiex/pcie.c  |  739 ++++++++++++++++++++++------------
 drivers/net/wireless/mwifiex/pcie.h  |  212 ++++++++--
 3 files changed, 659 insertions(+), 296 deletions(-)

