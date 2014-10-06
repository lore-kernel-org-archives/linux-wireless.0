Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39211 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbaJFNZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 09:25:21 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 0/4] ath10k: Add tracing for tx and rx frames
Date: Mon, 6 Oct 2014 18:57:00 +0530
Message-ID: <1412602024-31706-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141006_152529_998267_FC463639)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These changes are the extension of pktlog for dumping tx and rx
frames to user space. I am rebasing Michal's work on top of pktlog.

-Rajkumar

Michal Kazior (3):
  ath10k: add tracepoint for wmi mgmt tx frames
  ath10k: add tracepoint for wmi bcn tx
  ath10k: add htt rx tracepoints

Rajkumar Manoharan (1):
  ath10k: add tracepoint for htt tx frames

 drivers/net/wireless/ath/ath10k/htt_rx.c |  3 +
 drivers/net/wireless/ath/ath10k/htt_tx.c |  3 +-
 drivers/net/wireless/ath/ath10k/trace.h  | 94 ++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.c    |  2 +
 4 files changed, 97 insertions(+), 5 deletions(-)

-- 
2.1.2

