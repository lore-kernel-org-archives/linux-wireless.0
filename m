Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:1352 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbbGGQvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 12:51:08 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/3] ath10k: update data path to support QCA99X0
Date: Tue, 7 Jul 2015 09:47:53 -0700
Message-ID: <1436287676-25767-1-git-send-email-poh@qca.qualcomm.com> (sfid-20150707_185113_320977_C7F4AD19)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series update ath10k HTT Tx/Rx path to support
QCA99X0 chip and make it able to run data traffic on both of
Tx and Rx path.

Peter Oh (3):
  ath10k: update tx path to support QCA99X0
  ath10k: redefine rx_ppdu_end_common structure to cover qca99x0
  ath10k: add support for qca99x0 Rx descriptors

 drivers/net/wireless/ath/ath10k/htt.h     |  13 ++-
 drivers/net/wireless/ath/ath10k/htt_rx.c  |  24 ++--
 drivers/net/wireless/ath/ath10k/htt_tx.c  |  29 +++--
 drivers/net/wireless/ath/ath10k/rx_desc.h | 175 ++++++++++++++++++++++++++++--
 4 files changed, 212 insertions(+), 29 deletions(-)

-- 
1.9.1

