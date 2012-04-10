Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:51035 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2DJMSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 08:18:30 -0400
Subject: [PATCH 0/2] linux-firmware: ath6k update 20120410
To: ben@decadent.org.uk
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: dwmw2@infradead.org, ath6kl-devel@qualcomm.com,
	linux-wireless@vger.kernel.org
Date: Tue, 10 Apr 2012 15:18:21 +0300
Message-ID: <20120410121708.15361.62740.stgit@x201> (sfid-20120410_141835_685515_DECC87F4)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Resending as my --cc had a space and stgit didn't send this to the mailing
lists.)

Hi Ben,

here's a firmware update for ath6k. We update the AR6003 hw2.1.1 to the
latest in our 3.2.0 branch and add a new firmware for AR6004.

This is the first time I'm sending patches for linux-firmware so please
let me know if there are any errors.

---

Kalle Valo (2):
      linux-firmware: ath6k: add AR6003 hw2.1.1 firmware version 3.2.0.144
      linux-firmware: ath6k: add firmware for AR6004 hw1.2


 WHENCE                        |    5 +++++
 ath6k/AR6003/hw2.1.1/fw-3.bin |  Bin
 ath6k/AR6004/hw1.2/bdata.bin  |  Bin
 ath6k/AR6004/hw1.2/fw-2.bin   |  Bin
 4 files changed, 5 insertions(+), 0 deletions(-)
 create mode 100644 ath6k/AR6003/hw2.1.1/fw-3.bin
 create mode 100644 ath6k/AR6004/hw1.2/bdata.bin
 create mode 100644 ath6k/AR6004/hw1.2/fw-2.bin

