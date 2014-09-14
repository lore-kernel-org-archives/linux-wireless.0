Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:32774 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaINJmf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 05:42:35 -0400
Subject: [PATCH 00/10] ath10k: checkpatch fixes from v3.17
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 14 Sep 2014 12:49:55 +0300
Message-ID: <20140914094728.9063.32593.stgit@x230> (sfid-20140914_114238_793411_D4CFFCCD)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

some fixes to recently added checkpatch warnings. Please review.

Kalle

---

Kalle Valo (10):
      ath10k: fix parenthesis alignment warning in ath10k_htt_rx_alloc()
      ath10k: fix checkpatch warnings about parenthesis alignment
      ath10k: fix use of multiple blank lines
      ath10k: fix missing a blank line after declarations
      ath10k: fix space after a cast style errors
      ath10k: don't use return on void functions
      ath10k: else is not generally useful after a break or return
      ath10k: miscellaneous checkpatch fixes
      ath10k: reformat help text in ath10k_read_simulate_fw_crash()
      ath10k: use ether_addr_copy()


 drivers/net/wireless/ath/ath10k/bmi.h       |    1 
 drivers/net/wireless/ath/ath10k/ce.c        |    2 -
 drivers/net/wireless/ath/ath10k/ce.h        |   13 ++---
 drivers/net/wireless/ath/ath10k/debug.c     |   33 ++++++--------
 drivers/net/wireless/ath/ath10k/hif.h       |    1 
 drivers/net/wireless/ath/ath10k/htc.c       |   10 +---
 drivers/net/wireless/ath/ath10k/htc.h       |    1 
 drivers/net/wireless/ath/ath10k/htt.c       |    2 -
 drivers/net/wireless/ath/ath10k/htt.h       |    3 -
 drivers/net/wireless/ath/ath10k/htt_rx.c    |   52 +++++++++++----------
 drivers/net/wireless/ath/ath10k/htt_tx.c    |    2 -
 drivers/net/wireless/ath/ath10k/mac.c       |   45 ++++++++----------
 drivers/net/wireless/ath/ath10k/pci.c       |   37 ++++++++-------
 drivers/net/wireless/ath/ath10k/rx_desc.h   |    1 
 drivers/net/wireless/ath/ath10k/targaddrs.h |    1 
 drivers/net/wireless/ath/ath10k/txrx.c      |    2 -
 drivers/net/wireless/ath/ath10k/wmi.c       |   66 ++++++++++++++-------------
 drivers/net/wireless/ath/ath10k/wmi.h       |   17 ++-----
 18 files changed, 132 insertions(+), 157 deletions(-)
