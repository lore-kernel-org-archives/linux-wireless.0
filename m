Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:39601 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab3ICInw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 04:43:52 -0400
Subject: [PATCH 0/3] ath10k: HTT stats
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 Sep 2013 11:43:48 +0300
Message-ID: <20130903084302.26199.3538.stgit@localhost6.localdomain6> (sfid-20130903_104355_336008_09F27B10)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adds trace events and a debugfs interface to enable HTT stats
from firmware.

---

Kalle Valo (3):
      ath10k: add trace event ath10k_htt_stats
      ath10k: implement ath10k_debug_start/stop()
      ath10k: add htt_stats_enable debugfs file


 drivers/net/wireless/ath/ath10k/core.c   |    6 +
 drivers/net/wireless/ath/ath10k/core.h   |    3 +
 drivers/net/wireless/ath/ath10k/debug.c  |  121 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h  |   11 +++
 drivers/net/wireless/ath/ath10k/htt.h    |    1 
 drivers/net/wireless/ath/ath10k/htt_rx.c |    5 +
 drivers/net/wireless/ath/ath10k/htt_tx.c |   42 ++++++++++
 drivers/net/wireless/ath/ath10k/trace.h  |   21 +++++
 8 files changed, 209 insertions(+), 1 deletion(-)

