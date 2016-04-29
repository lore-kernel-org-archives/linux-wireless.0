Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31862 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbcD2RnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2016 13:43:05 -0400
Subject: [PATCH 0/4] linux-firmware: ath10k: add QCA9377 and update QCA6174
 images
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-firmware@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Date: Fri, 29 Apr 2016 20:42:53 +0300
Message-ID: <20160429173841.9072.66852.stgit@potku.adurom.net> (sfid-20160429_194309_792789_B4A43387)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

here are firmware images for the new QCA9377 chip and updates for QCA6174.

Kalle

---

Kalle Valo (4):
      ath10k: QCA6174 hw2.1: update firmware-5.bin to SW_RM.1.1.1-00157-QCARMSWPZ-1
      ath10k: QCA6174 hw2.1: add board-2.bin
      ath10k: QCA6174 hw3.0: add board-2.bin
      ath10k: QCA9377 hw1.0: add firmware and board files


 WHENCE                                            |    9 
 ath10k/QCA6174/hw2.1/board-2.bin                  |  Bin
 ath10k/QCA6174/hw2.1/firmware-5.bin               |  Bin
 ath10k/QCA6174/hw3.0/board-2.bin                  |  Bin
 ath10k/QCA9377/hw1.0/board-2.bin                  |  Bin
 ath10k/QCA9377/hw1.0/board.bin                    |  Bin
 ath10k/QCA9377/hw1.0/firmware-5.bin               |  Bin
 ath10k/QCA9377/hw1.0/notice_ath10k_firmware-5.txt | 1128 +++++++++++++++++++++
 8 files changed, 1136 insertions(+), 1 deletion(-)
 create mode 100644 ath10k/QCA6174/hw2.1/board-2.bin
 create mode 100644 ath10k/QCA6174/hw3.0/board-2.bin
 create mode 100644 ath10k/QCA9377/hw1.0/board-2.bin
 create mode 100644 ath10k/QCA9377/hw1.0/board.bin
 create mode 100644 ath10k/QCA9377/hw1.0/firmware-5.bin
 create mode 100644 ath10k/QCA9377/hw1.0/notice_ath10k_firmware-5.txt

