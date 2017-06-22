Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:12858 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751116AbdFVIcz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 04:32:55 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-firmware@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: [PATCH 00/12] ath10k: firmware update 20170621
Date: Thu, 22 Jun 2017 11:31:56 +0300
Message-ID: <1498120328-2017-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20170622_103300_065285_D971DD17)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

here's a set of firmware and board file updates for ath10k.

Kalle

Kalle Valo (12):
  ath10k: QCA4019 hw1.0: update board-2.bin
  ath10k: QCA4019 hw1.0: update firmware to 10.4-3.4-00082
  ath10k: QCA6174 hw3.0: update board-2.bin
  ath10k: QCA6174 hw3.0: add WLAN.RM.4.4-00022-QCARMSWPZ-2
  ath10k: QCA9377 hw1.0: update board-2.bin
  ath10k: QCA9887 hw1.0: update firmware to 10.2.4-1.0-00029
  ath10k: QCA9888 hw2.0: update board-2.bin
  ath10k: QCA9888 hw2.0: update firmware to 10.4-3.5.1-00014
  ath10k: QCA988X hw2.0: update firmware to 10.2.4.70.63-2
  ath10k: QCA9984 hw1.0: update board-2.bin
  ath10k: QCA9984 hw1.0: update firmware to 10.4-3.4-00082
  ath10k: update year in license

 LICENSE.QualcommAtheros_ath10k                    |    2 +-
 WHENCE                                            |   13 +-
 ath10k/QCA4019/hw1.0/board-2.bin                  |  Bin 72788 -> 109172 bytes
 ath10k/QCA4019/hw1.0/firmware-5.bin               |  Bin 512520 -> 535412 bytes
 ath10k/QCA6174/hw3.0/board-2.bin                  |  Bin 361924 -> 477060 bytes
 ath10k/QCA6174/hw3.0/firmware-6.bin               |  Bin 0 -> 711408 bytes
 ath10k/QCA6174/hw3.0/notice_ath10k_firmware-6.txt | 1781 +++++++++++++++++++++
 ath10k/QCA9377/hw1.0/board-2.bin                  |  Bin 427668 -> 304308 bytes
 ath10k/QCA9887/hw1.0/firmware-5.bin               |  Bin 234560 -> 235880 bytes
 ath10k/QCA9888/hw2.0/board-2.bin                  |  Bin 12148 -> 72788 bytes
 ath10k/QCA9888/hw2.0/firmware-5.bin               |  Bin 565168 -> 647460 bytes
 ath10k/QCA988X/hw2.0/firmware-5.bin               |  Bin 248188 -> 249384 bytes
 ath10k/QCA9984/hw1.0/board-2.bin                  |  Bin 12144 -> 121264 bytes
 ath10k/QCA9984/hw1.0/firmware-5.bin               |  Bin 591308 -> 622060 bytes
 14 files changed, 1790 insertions(+), 6 deletions(-)
 create mode 100644 ath10k/QCA6174/hw3.0/firmware-6.bin
 create mode 100644 ath10k/QCA6174/hw3.0/notice_ath10k_firmware-6.txt

-- 
2.7.4
