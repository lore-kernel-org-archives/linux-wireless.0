Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:45198 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932312AbdIRPBR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 11:01:17 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-firmware@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: [PATCH 0/3] linux-firmware: ath10k update 20170918
Date: Mon, 18 Sep 2017 18:00:54 +0300
Message-ID: <1505746857-31938-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20170918_170120_524947_56A657ED)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Few firmware fixes to user reported issues for ath10k, but the other "fix"
being a revert back to older firmware. Also a small board-2.bin update.

Kalle Valo (3):
  ath10k: QCA6174 hw3.0: update firmware-6.bin to
    WLAN.RM.4.4.1-00051-QCARMSWP-1
  ath10k: QCA6174 hw3.0: update board-2.bin
  Revert "ath10k: QCA988X hw2.0: update firmware to 10.2.4.70.63-2"

 WHENCE                                            |   4 +-
 ath10k/QCA6174/hw3.0/board-2.bin                  | Bin 477060 -> 501748 bytes
 ath10k/QCA6174/hw3.0/firmware-6.bin               | Bin 711408 -> 727776 bytes
 ath10k/QCA6174/hw3.0/notice_ath10k_firmware-6.txt |  97 +++++-----------------
 ath10k/QCA988X/hw2.0/firmware-5.bin               | Bin 249384 -> 248188 bytes
 5 files changed, 25 insertions(+), 76 deletions(-)

-- 
2.7.4
