Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36391 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755733AbdCLNIj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Mar 2017 09:08:39 -0400
Received: by mail-pf0-f195.google.com with SMTP id j5so16062443pfb.3
        for <linux-wireless@vger.kernel.org>; Sun, 12 Mar 2017 06:08:39 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Cathy Luo <cluo@marvell.com>
Subject: pull-request mwifiex-firmware 2017-03-11
Date: Sun, 12 Mar 2017 13:08:33 +0000
Message-Id: <1489324113-22129-1-git-send-email-huxinming820@gmail.com> (sfid-20170312_140842_735015_0872F703)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 8f171e29aade68e8a9193e288ba526e6f8fa7575:

  linux-firmware: update Marvell PCIe-USB8997 firmware image (2017-02-20 18:17:17 +0530)

are available in the git repository at:

  git://git.marvell.com/mwifiex-firmware.git 

for you to fetch changes up to 59d72586fbaa71cdf3a9f0e0ea2bb169f80d9e6b:

  linux-firmware: update Marvell PCIe-USB8997 wifi-only firmware image (2017-03-11 02:31:18 -0800)

----------------------------------------------------------------
Xinming Hu (1):
      linux-firmware: update Marvell PCIe-USB8997 wifi-only firmware image

 WHENCE                    |   3 +++
 mrvl/pcie8997_wlan_v4.bin | Bin 0 -> 428788 bytes
 2 files changed, 3 insertions(+)
 create mode 100755 mrvl/pcie8997_wlan_v4.bin
