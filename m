Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58274 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaKXQlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 11:41:55 -0500
Subject: [PATCH v2 0/2] ath10k: firmware memory debugfs interface
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Mon, 24 Nov 2014 18:41:38 +0200
Message-ID: <20141124164037.29422.14033.stgit@potku.adurom.net> (sfid-20141124_174158_347150_5F67856E)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

this is v2 of Yanbo's firmware memory debugfs interface.

Changelog:

v2:

* split patches into two

* simplify the commit logs

* remove extra #include "hif.h" from debug.c

---

Yanbo Li (2):
      ath10k: add register access debugfs interface
      ath10k: add memory dump debugfs interface


 drivers/net/wireless/ath/ath10k/core.h  |    2 
 drivers/net/wireless/ath/ath10k/debug.c |  188 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hif.h   |   37 ++++++
 drivers/net/wireless/ath/ath10k/pci.c   |    3 
 4 files changed, 230 insertions(+)

