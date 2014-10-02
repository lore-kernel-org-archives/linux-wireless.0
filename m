Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2323 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaJBMKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 08:10:55 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 0/4] ath10k: Add pktlog support
Date: Thu, 2 Oct 2014 17:42:10 +0530
Message-ID: <1412251934-7011-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141002_141059_614463_AC784529)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements the Packet log feature for ath10k.
All tx and rx events and rx descriptor details are
posted to user space by tracepoints.

Rajkumar Manoharan (4):
  ath10k: Add support to configure pktlog filter
  ath10k: add tracing for ath10k_htt_pktlog
  ath10k: add tracing for rx descriptor
  ath10k: add tracing for tx msdu pktlog event

 drivers/net/wireless/ath/ath10k/core.h   |  2 +
 drivers/net/wireless/ath/ath10k/debug.c  | 80 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/debug.h  | 15 +++++-
 drivers/net/wireless/ath/ath10k/htt.h    |  2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c | 47 +++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h     | 35 +++++++++++++
 drivers/net/wireless/ath/ath10k/trace.h  | 89 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c    | 33 ++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h    |  6 +++
 9 files changed, 306 insertions(+), 3 deletions(-)

-- 
2.1.1

