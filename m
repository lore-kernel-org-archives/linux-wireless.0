Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13148 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbcF0JA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 05:00:58 -0400
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCHV2 0/3] Add testmode support for 10.4
Date: Mon, 27 Jun 2016 14:36:11 +0530
Message-ID: <1467018371-24416-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20160627_110102_127951_01D99D10)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

*The below patches add testmode support for 10.4.

*Some of the codeswap related code in ath10k for example code
which  initializes the code swap segment works only on normal fw,
below patches  make such code generic so that it can be used
for utf binary as well.

Tamizh chelvam (3):
  ath10k: move firmware_swap_code_seg_info to ath10k_fw_file
  ath10k: handle testmode events for 10.2 and 10.4 based firmware
  ath10k: add testmode support for 10.4 firmware

V2:
  * changed author and signed off mail id.

 drivers/net/wireless/ath/ath10k/core.c     |    6 +++---
 drivers/net/wireless/ath/ath10k/core.h     |    6 ++----
 drivers/net/wireless/ath/ath10k/swap.c     |   26 ++++++++++++++------------
 drivers/net/wireless/ath/ath10k/swap.h     |   11 ++++++++---
 drivers/net/wireless/ath/ath10k/testmode.c |   23 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c      |   26 ++++++++++++++++++++++++++
 6 files changed, 76 insertions(+), 22 deletions(-)

-- 
1.7.9.5

