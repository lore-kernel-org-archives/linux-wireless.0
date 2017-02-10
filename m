Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3189 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752125AbdBJM2E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 07:28:04 -0500
Subject: [PATCH v2 0/4] ath10k: silence firmware file probing warnings
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 10 Feb 2017 14:26:20 +0200
Message-ID: <148672934198.8556.5588600166627442652.stgit@potku.adurom.net> (sfid-20170210_132811_986842_9DA6722D)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

here are patches to make ath10k less spammy during initialisation.

v2:

* RFC -> PATCH

* add new patches:

  ath10k: fetch firmware images in a loop
  ath10k: add directory to board data error message
  ath10k: convert warning about non-existent OTP board id to debug message

---

Erik Stromdahl (1):
      ath10k: fetch firmware images in a loop

Kalle Valo (2):
      ath10k: add directory to board data error message
      ath10k: convert warning about non-existent OTP board id to debug message

Michal Kazior (1):
      ath10k: silence firmware file probing warnings


 drivers/net/wireless/ath/ath10k/core.c     |   68 +++++++++++++---------------
 drivers/net/wireless/ath/ath10k/hw.h       |    4 ++
 drivers/net/wireless/ath/ath10k/testmode.c |    5 ++
 3 files changed, 40 insertions(+), 37 deletions(-)
