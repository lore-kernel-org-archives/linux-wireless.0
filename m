Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47670 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932417AbcHXLcV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Aug 2016 07:32:21 -0400
Subject: [PATCH v2 0/6] linux-firmware: ath10k: update and add various
 firmware files
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-firmware@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Date: Wed, 24 Aug 2016 14:32:10 +0300
Message-ID: <20160824113134.5625.35574.stgit@potku.adurom.net> (sfid-20160824_133225_755266_4F1940F3)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

here's a bigger ath10k firmware update. Support for four new hardware
and smaller updates for existing hardware.

Kalle

v2:

* patch 4: Fix a typo in the commit log.

---

Kalle Valo (6):
      ath10k: QCA4019 hw1.0: add firmware and board files
      ath10k: QCA9887 hw1.0: add firmware and board files
      ath10k: QCA9888 hw2.0: add firmware and board files
      ath10k: QCA9984 hw1.0: add firmware and board files
      ath10k: QCA988X hw2.0: update firmware to 10.2.4.70.54
      ath10k: QCA6174: update board files


 WHENCE                                            |   18 +
 ath10k/QCA4019/hw1.0/board-2.bin                  |  Bin
 ath10k/QCA4019/hw1.0/firmware-5.bin               |  Bin
 ath10k/QCA4019/hw1.0/notice_ath10k_firmware-5.txt |  589 +++++++++++++++++++++
 ath10k/QCA6174/hw2.1/board-2.bin                  |  Bin
 ath10k/QCA6174/hw3.0/board-2.bin                  |  Bin
 ath10k/QCA9887/hw1.0/board.bin                    |  Bin
 ath10k/QCA9887/hw1.0/firmware-5.bin               |  Bin
 ath10k/QCA9887/hw1.0/notice_ath10k_firmware-5.txt |  328 ++++++++++++
 ath10k/QCA9888/hw2.0/board-2.bin                  |  Bin
 ath10k/QCA9888/hw2.0/firmware-5.bin               |  Bin
 ath10k/QCA9888/hw2.0/notice_ath10k_firmware-5.txt |  589 +++++++++++++++++++++
 ath10k/QCA988X/hw2.0/firmware-5.bin               |  Bin
 ath10k/QCA988X/hw2.0/notice_ath10k_firmware-5.txt |   44 +-
 ath10k/QCA9984/hw1.0/board-2.bin                  |  Bin
 ath10k/QCA9984/hw1.0/firmware-5.bin               |  Bin
 ath10k/QCA9984/hw1.0/notice_ath10k_firmware-5.txt |  589 +++++++++++++++++++++
 17 files changed, 2134 insertions(+), 23 deletions(-)
 create mode 100644 ath10k/QCA4019/hw1.0/board-2.bin
 create mode 100644 ath10k/QCA4019/hw1.0/firmware-5.bin
 create mode 100644 ath10k/QCA4019/hw1.0/notice_ath10k_firmware-5.txt
 create mode 100644 ath10k/QCA9887/hw1.0/board.bin
 create mode 100644 ath10k/QCA9887/hw1.0/firmware-5.bin
 create mode 100644 ath10k/QCA9887/hw1.0/notice_ath10k_firmware-5.txt
 create mode 100644 ath10k/QCA9888/hw2.0/board-2.bin
 create mode 100644 ath10k/QCA9888/hw2.0/firmware-5.bin
 create mode 100644 ath10k/QCA9888/hw2.0/notice_ath10k_firmware-5.txt
 create mode 100644 ath10k/QCA9984/hw1.0/board-2.bin
 create mode 100644 ath10k/QCA9984/hw1.0/firmware-5.bin
 create mode 100644 ath10k/QCA9984/hw1.0/notice_ath10k_firmware-5.txt
