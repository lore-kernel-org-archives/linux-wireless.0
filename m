Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:10388 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbbIRH6b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 03:58:31 -0400
Subject: [PATCH 0/2] ath10k: implement debugfs interface for Transmit Power
 Control stats
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 18 Sep 2015 10:58:22 +0300
Message-ID: <20150918075706.6983.11216.stgit@potku.adurom.net> (sfid-20150918_095834_424182_7733DA90)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements a simple interface for debugging TPC stats. I did a small hack
to sparse to check endian usage with signed 32 bit values.

---

Kalle Valo (1):
      ath10k: add a_sle32_to_cpu()

Maharaja Kennadyrajan (1):
      ath10k: implement debugfs interface for Transmit Power Control stats


 drivers/net/wireless/ath/ath10k/core.h    |   29 +++
 drivers/net/wireless/ath/ath10k/debug.c   |  233 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h   |    8 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h |   19 ++
 drivers/net/wireless/ath/ath10k/wmi.c     |  269 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |   36 ++++
 6 files changed, 592 insertions(+), 2 deletions(-)

