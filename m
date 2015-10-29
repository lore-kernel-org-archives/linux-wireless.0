Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:62898 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbbJ2NmA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 09:42:00 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 0/3] Add new WMI defines to 10.4
Date: Thu, 29 Oct 2015 19:11:31 +0530
Message-ID: <1446126094-30880-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20151029_144204_895634_40A1DCF2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set does not have any real functionality changes.
Adds new WMI defines to be in sync with 10.4 firmware.

Vasanthakumar Thiagarajan (3):
  ath10k: Add new service defines for 10.4
  ath10k: Add new WMI cmd/event defines for 10.4
  ath10k: Add new pdev params defines to 10.4

 drivers/net/wireless/ath/ath10k/wmi.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

-- 
1.9.1

