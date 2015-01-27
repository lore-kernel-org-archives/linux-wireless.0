Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16864 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbbA0FmB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 00:42:01 -0500
From: Avinash Patil <patila@marvell.com>
To: <linux-firmware@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <frankh@marvell.com>,
	<cluo@marvell.com>, <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: pull-request mwifiex-firmware 2015-01-27 
Date: Tue, 27 Jan 2015 16:41:24 +0530
Message-ID: <1422357084-21759-1-git-send-email-patila@marvell.com> (sfid-20150127_064205_786092_818AA9DB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit dec41bce44e0dff6a2c3358a958fadf22bf58858:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware (2014-03-16 18:12:54 +0000)

are available in the git repository at:


  git://git.marvell.com/mwifiex-firmware.git master

for you to fetch changes up to 7f02df82736a85606cd9f33cb709545d9fc5326e:

  linux-firmware: update Marvell 8897-B0 firmware images to p112 (2015-01-27 16:02:53 +0530)

----------------------------------------------------------------
Avinash Patil (8):
      linux-firmware: update Marvell SD8787 firmware version p52
      linux-firmware: update Marvell 8897-B0 firmware images to p103
      linux-firmware: update WHENCE file for Marvell 8897 FW versions
      linux-firmware: update Marvell USB8797-B0 firmware image
      linux-firmware: add Marvell 8887-A2 firmware image
      linux-firmware: add Marvell USB8766-A0 firmware combo image
      linux-firmware: update Marvell 8897-B0 firmware images to p106
      linux-firmware: update Marvell 8897-B0 firmware images to p112

Bing Zhao (6):
      linux-firmware: update Marvell USB8797-B0 firmware image
      linux-firmware: update Marvell SD8897-B0 firmware combo image
      linux-firmware: update Marvell PCIe/USB 8897-B0 firmware combo image
      linux-firmware: add Marvell USB8897-B0 firmware combo image
      linux-firmware: update Marvell 8897-B0 firmware images to p73
      linux-firmware: update Marvell SD8787 firmware version p192

 WHENCE                   |  19 ++++++++++++++-----
 mrvl/pcie8897_uapsta.bin | Bin 656896 -> 759128 bytes
 mrvl/sd8787_uapsta.bin   | Bin 447384 -> 463240 bytes
 mrvl/sd8887_uapsta.bin   | Bin 0 -> 391772 bytes
 mrvl/sd8897_uapsta.bin   | Bin 639012 -> 734612 bytes
 mrvl/usb8766_uapsta.bin  | Bin 0 -> 478836 bytes
 mrvl/usb8797_uapsta.bin  | Bin 508372 -> 551720 bytes
 mrvl/usb8897_uapsta.bin  | Bin 0 -> 752340 bytes
 8 files changed, 14 insertions(+), 5 deletions(-)
 create mode 100755 mrvl/sd8887_uapsta.bin
 create mode 100755 mrvl/usb8766_uapsta.bin
 create mode 100644 mrvl/usb8897_uapsta.bin

