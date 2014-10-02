Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:61684 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaJBMEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 08:04:46 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 0/4] ath10k: Add pktlog support
Date: Thu, 2 Oct 2014 17:36:06 +0530
Message-ID: <1412251570-31096-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141002_140449_815546_3BD15264)
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

