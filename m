Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38656 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750832AbeAPLAC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 06:00:02 -0500
From: Xinming Hu <huxm@marvell.com>
To: Linux Firmware <linux-firmware@kernel.org>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Bob Tan <tanbo@marvell.com>, Xu Wang <xwang4@marvell.com>
Subject: pull-request mwifiex-firmware 2018-01-16
Date: Tue, 16 Jan 2018 18:59:52 +0800
Message-ID: <1516100392-10271-1-git-send-email-huxm@marvell.com> (sfid-20180116_120015_515676_58ABA715)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit db3e1855ea46bc1a22b8bbecb400c2909c551cf5:

  linux-firmware: update Marvell PCIe-USB8997 firmware image (2017-10-31 20:49:53 +0530)

are available in the git repository at:

  git://git.marvell.com/mwifiex-firmware.git master

for you to fetch changes up to 5446916b53de395245d89400dea566055ec4502c:

  linux-firmware: update Marvell PCIe-USB8897/8997 firmware image to add WPA2 vulnerability fix (2018-01-16 01:45:00 -0800)

----------------------------------------------------------------
Xinming Hu (1):
      linux-firmware: update Marvell PCIe-USB8897/8997 firmware image to add WPA2 vulnerability fix

 WHENCE                        |   4 ++--
 mrvl/pcie8897_uapsta.bin      | Bin 836540 -> 843828 bytes
 mrvl/pcieusb8997_combo_v4.bin | Bin 622532 -> 631012 bytes
 3 files changed, 2 insertions(+), 2 deletions(-)
