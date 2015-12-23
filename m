Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58562 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479AbbLWJhA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2015 04:37:00 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC: Frank Huang <frankh@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull-request mwifiex-firmware 2015-12-23
Date: Wed, 23 Dec 2015 09:36:58 +0000
Message-ID: <2b4ceab04f0e4bcf9b5b94a0d259b9d3@SC-EXCH04.marvell.com> (sfid-20151223_103709_092288_85B07100)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 7f02df82736a85606cd9f33cb709545d9fc5326e:

  linux-firmware: update Marvell 8897-B0 firmware images to p112 (2015-01-27 16:02:53 +0530)

are available in the git repository at:

  git://git.marvell.com/mwifiex-firmware.git master

for you to fetch changes up to e92f8b3f65443764297b947b1843955d9a65dde7:

  linux-firmware: update Marvell USB8797-B0 firmware image (2015-11-02 06:25:05 -0500)

----------------------------------------------------------------
Amitkumar Karwar (3):
      linux-firmware: update Marvell 8897-B0 firmware images to 7.p18
      linux-firmware: update Marvell 8897-B0 firmware images to 7.p53
      linux-firmware: update Marvell USB8797-B0 firmware image

Avinash Patil (1):
      linux-firmware: add Marvell SD/USB8801 B0 firmware images

 WHENCE                   |  12 +++++++++---
 mrvl/pcie8897_uapsta.bin | Bin 759128 -> 803884 bytes
 mrvl/sd8801_uapsta.bin   | Bin 0 -> 258680 bytes
 mrvl/sd8897_uapsta.bin   | Bin 734612 -> 780760 bytes
 mrvl/usb8797_uapsta.bin  | Bin 551720 -> 553456 bytes
 mrvl/usb8801_uapsta.bin  | Bin 0 -> 255948 bytes
 6 files changed, 9 insertions(+), 3 deletions(-)
 create mode 100755 mrvl/sd8801_uapsta.bin
 create mode 100755 mrvl/usb8801_uapsta.bin
