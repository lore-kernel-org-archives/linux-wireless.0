Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46961 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbcCXOXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2016 10:23:25 -0400
Subject: [PATCH 0/4] ath10k: fix recent checkpatch warnings
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 24 Mar 2016 16:23:07 +0200
Message-ID: <20160324142217.15808.22638.stgit@potku.adurom.net> (sfid-20160324_152329_043450_0125BD87)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I updated checkpatch and noticed that there are few new warnings.

---

Kalle Valo (4):
      ath10k: fix checkpatch warnings related to spaces
      ath10k: prefer kernel type 'u64' over 'u_int64_t'
      ath10k: prefer ether_addr_equal() or ether_addr_equal_unaligned() over memcmp()
      ath10k: prefer ether_addr_copy() over memcpy()


 drivers/net/wireless/ath/ath10k/ce.c        |    6 +++---
 drivers/net/wireless/ath/ath10k/ce.h        |    2 +-
 drivers/net/wireless/ath/ath10k/core.h      |    6 +++---
 drivers/net/wireless/ath/ath10k/debug.h     |    2 +-
 drivers/net/wireless/ath/ath10k/htc.h       |    4 ++--
 drivers/net/wireless/ath/ath10k/htt.c       |    2 +-
 drivers/net/wireless/ath/ath10k/htt.h       |    4 ++--
 drivers/net/wireless/ath/ath10k/mac.c       |   12 ++++++------
 drivers/net/wireless/ath/ath10k/targaddrs.h |    2 +-
 drivers/net/wireless/ath/ath10k/thermal.h   |    2 +-
 drivers/net/wireless/ath/ath10k/txrx.c      |    4 ++--
 drivers/net/wireless/ath/ath10k/wmi-tlv.h   |    4 ++--
 drivers/net/wireless/ath/ath10k/wmi.c       |    7 +++----
 drivers/net/wireless/ath/ath10k/wmi.h       |   18 +++++++++---------
 14 files changed, 37 insertions(+), 38 deletions(-)

