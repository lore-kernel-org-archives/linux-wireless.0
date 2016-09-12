Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52734 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1758566AbcILMk2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 08:40:28 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Subject: pull-request mwifiex-firmware 2015-09-12
Date: Mon, 12 Sep 2016 12:40:23 +0000
Message-ID: <bf3662bacb394fc2aac0ff891a5100ea@SC-EXCH04.marvell.com> (sfid-20160912_144045_585272_6172045C)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit e92f8b3f65443764297b947b1843955d9a65dde7:

  linux-firmware: update Marvell USB8797-B0 firmware image (2015-11-02 06:25:05 -0500)

are available in the git repository at:

  git://git.marvell.com/mwifiex-firmware.git master

for you to fetch changes up to 1e0f28ad5a26b2c86e55dbad3141b2ec2de804f7:

  linux-firmware: update WHENCE file for Marvell firmware versions (2016-09-12 17:12:42 +0530)

----------------------------------------------------------------
Amitkumar Karwar (4):
      linux-firmware: update Marvell 8897-B0 firmware images to 7.p66
      linux-firmware: update Marvell 8897-B0 firmware images to 7.p77
      linux-firmware: add Marvell PCIe8997 firmware images
      linux-firmware: update WHENCE file for Marvell firmware versions

 WHENCE                         |  10 ++++++++--
 mrvl/pcie8897_uapsta.bin       | Bin 803884 -> 820212 bytes
 mrvl/pcieuart8997_combo_v4.bin | Bin 0 -> 583628 bytes
 mrvl/pcieusb8997_combo_v4.bin  | Bin 0 -> 589048 bytes
 mrvl/sd8897_uapsta.bin         | Bin 780760 -> 802164 bytes
 5 files changed, 8 insertions(+), 2 deletions(-)
 create mode 100644 mrvl/pcieuart8997_combo_v4.bin
 create mode 100644 mrvl/pcieusb8997_combo_v4.bin
