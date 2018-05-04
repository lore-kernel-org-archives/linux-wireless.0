Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37450 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751461AbeEDHeP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 May 2018 03:34:15 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Sachin Patki <spatki@marvell.com>,
        Prashanth Ranganathan <rprashk@marvell.com>,
        "Mayur Arakere" <mayur@marvell.com>,
        Sanjay Subbarao <jayrao@marvell.com>
Subject: pull-request mwifiex-firmware 2018-05-04
Date: Fri, 4 May 2018 07:34:12 +0000
Message-ID: <76132c14dc564054af97f3355dddf4e7@SC-EXCH02.marvell.com> (sfid-20180504_093420_946642_CD9836D8)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 5446916b53de395245d89400dea566055ec4502c:

  linux-firmware: update Marvell PCIe-USB8897/8997 firmware image to add WPA2 vulnerability fix (2018-01-16 01:45:00 -0800)

are available in the git repository at:

  git://git.marvell.com/mwifiex-firmware.git

for you to fetch changes up to 8b2f89bba6e8330c484f9ad39367d8efd42d23b4:

  linux-firmware: update Marvell USB8997 firmware image to add WPA2 vulnerability fix (2018-05-04 12:51:40 +0530)

----------------------------------------------------------------
Ganapathi Bhat (2):
      linux-firmware: update Marvell SD8897-B0 firmware image to add WPA2 vulnerability fix
      linux-firmware: update Marvell USB8997 firmware image to add WPA2 vulnerability fix

WHENCE                       |   4 ++--
mrvl/sd8897_uapsta.bin       | Bin 814048 -> 821024 bytes
mrvl/usbusb8997_combo_v4.bin | Bin 602100 -> 604536 bytes
3 files changed, 2 insertions(+), 2 deletions(-)
