Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45945 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbcDTO7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 10:59:45 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 0/4] Add support for QCA9984
Date: Wed, 20 Apr 2016 20:29:12 +0530
Message-ID: <1461164356-9158-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20160420_165949_120489_44CDD33A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set adds QCA9984/QCA9994 1.0 support. Boot sequence is same as
QCA99X0.

Vasanthakumar Thiagarajan (4):
  ath10k: Move rx_location_info out of struct rx_pkt_end
  ath10k: Clean up growing hw checks during safe and full reset
  ath10k: Define rx_ppdu_end for QCA9984
  ath10k: Enable support for QCA9984

 drivers/net/wireless/ath/ath10k/core.c    | 23 ++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h      | 11 ++++++
 drivers/net/wireless/ath/ath10k/pci.c     | 58 ++++++++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/pci.h     |  6 ++++
 drivers/net/wireless/ath/ath10k/rx_desc.h | 48 ++++++++++++++++++++++++-
 5 files changed, 129 insertions(+), 17 deletions(-)

-- 
1.9.1

