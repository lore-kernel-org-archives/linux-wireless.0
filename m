Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:50710 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbcA2LFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 06:05:31 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 0/2] add hw param and wmi changes for qca4019
Date: Fri, 29 Jan 2016 16:35:10 +0530
Message-ID: <1454065512-8238-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20160129_120535_041597_12815ABF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series includes hw param and wmi changes needed for qca4019.

Raja Mani (2):
  ath10k: add qca4019 hw params
  ath10k: populate qca4019 fw specific wmi init params

 drivers/net/wireless/ath/ath10k/core.c      | 34 +++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/core.h      |  6 +++++
 drivers/net/wireless/ath/ath10k/hw.h        | 14 +++++++-----
 drivers/net/wireless/ath/ath10k/targaddrs.h |  3 +++
 drivers/net/wireless/ath/ath10k/wmi.c       | 12 +++++-----
 drivers/net/wireless/ath/ath10k/wmi.h       |  1 -
 6 files changed, 55 insertions(+), 15 deletions(-)

-- 
1.8.1.2

