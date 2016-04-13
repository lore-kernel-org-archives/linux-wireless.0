Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59135 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817AbcDMLNd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 07:13:33 -0400
Subject: [PATCH v2 0/5] ath10k: fix recent checkpatch warnings
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 13 Apr 2016 14:13:08 +0300
Message-ID: <20160413111247.18823.15952.stgit@potku.adurom.net> (sfid-20160413_131337_169892_76214888)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I updated checkpatch and noticed that there are few new warnings.

v2:

* fix tests in patch 3
* add patch 5 to fix a new warning in mac.c

---

Kalle Valo (5):
      ath10k: fix checkpatch warnings related to spaces
      ath10k: prefer kernel type 'u64' over 'u_int64_t'
      ath10k: prefer ether_addr_equal() or ether_addr_equal_unaligned() over memcmp()
      ath10k: prefer ether_addr_copy() over memcpy()
      ath10k: fix parenthesis alignment


 drivers/net/wireless/ath/ath10k/ce.c        |    6 +++---
 drivers/net/wireless/ath/ath10k/ce.h        |    2 +-
 drivers/net/wireless/ath/ath10k/core.h      |    6 +++---
 drivers/net/wireless/ath/ath10k/debug.h     |    2 +-
 drivers/net/wireless/ath/ath10k/htc.h       |    4 ++--
 drivers/net/wireless/ath/ath10k/htt.c       |    2 +-
 drivers/net/wireless/ath/ath10k/htt.h       |    4 ++--
 drivers/net/wireless/ath/ath10k/mac.c       |   14 +++++++-------
 drivers/net/wireless/ath/ath10k/targaddrs.h |    2 +-
 drivers/net/wireless/ath/ath10k/thermal.h   |    2 +-
 drivers/net/wireless/ath/ath10k/txrx.c      |    4 ++--
 drivers/net/wireless/ath/ath10k/wmi-tlv.h   |    4 ++--
 drivers/net/wireless/ath/ath10k/wmi.c       |    7 +++----
 drivers/net/wireless/ath/ath10k/wmi.h       |   18 +++++++++---------
 14 files changed, 38 insertions(+), 39 deletions(-)

