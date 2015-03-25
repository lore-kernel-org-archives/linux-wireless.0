Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:11881 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbbCYLMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2015 07:12:23 -0400
Subject: [PATCH v2 0/2] ath10k: add ATH10K_FW_IE_HTT_OP_VERSION
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 25 Mar 2015 13:12:13 +0200
Message-ID: <20150325110835.30133.509.stgit@x230> (sfid-20150325_121227_591258_435C5970)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My proposal how to solve the differences between HTT interfaces by adding
ATH10K_FW_IE_HTT_OP_VERSION. Based on Rajkumar's "ath10k: fix htt t2h message
conflicts among firmware revisions", I just added the new IE and bumped up the
FW API.

For now only compile tested, I will run proper tests later.

---

Kalle Valo (1):
      ath10k: bump up FW API to 5

Rajkumar Manoharan (1):
      ath10k: add ATH10K_FW_IE_HTT_OP_VERSION


 drivers/net/wireless/ath/ath10k/core.c   |   18 ++++
 drivers/net/wireless/ath/ath10k/htt.c    |   98 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/htt.h    |  130 ++++++++++++++++++++++++------
 drivers/net/wireless/ath/ath10k/htt_rx.c |   20 +++--
 drivers/net/wireless/ath/ath10k/hw.h     |   22 +++++
 drivers/net/wireless/ath/ath10k/pci.c    |    1 
 6 files changed, 256 insertions(+), 33 deletions(-)

