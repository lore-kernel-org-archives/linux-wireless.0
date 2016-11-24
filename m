Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33011 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756883AbcKXIWC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 03:22:02 -0500
Received: by mail-pg0-f67.google.com with SMTP id 3so2887694pgd.0
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2016 00:22:02 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Thu, 24 Nov 2016 00:01:06 -0800
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Raja Mani <rmani@qti.qualcomm.com>,
        Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/5] Fix -Wunused-but-set-variable in ath10k/
Message-ID: <cover.1479974100.git.kirtika@chromium.org> (sfid-20161124_092212_181135_F7ECCE26)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset is part of the effort led by Arnd Bergmann to clean up
warnings in the kernel. This and following patchsets will focus on
"-Wunused-but-set-variable" as it among the noisier ones. These were
found compiling with W=1.

Kirtika Ruchandani (5):
  ath10k: Remove unused 'buf_len' variable
  ath10k: Remove unused 'num_vdev_stats' variable
  ath10k: Remove unused wmi_p2p_noa_descriptor 'noa' in wmi-tlv
  ath10k: Removed unused 'dev' in ath10k_ahb_clock_enable()
  ath10k: Removed unused 'dev' in ath10k_ahb_resource_init

 drivers/net/wireless/ath/ath10k/ahb.c     |  5 -----
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  2 --
 drivers/net/wireless/ath/ath10k/wmi.c     | 14 ++------------
 3 files changed, 2 insertions(+), 19 deletions(-)

--
2.8.0.rc3.226.g39d4020
