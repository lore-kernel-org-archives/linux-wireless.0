Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29747 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbbJYN7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 09:59:34 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 0/4] wil6210 patches
Date: Sun, 25 Oct 2015 15:59:20 +0200
Message-Id: <1445781564-24455-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20151025_145938_212621_B1D09343)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Collection of small fixes

Hamad Kadmany (1):
  wil6210: Fix TSO overflow handling

Vladimir Kondratiev (3):
  wil6210: ignore selected WMI events
  wil6210: fix device ready detection
  wil6210: handle failure in Tx vring config

 drivers/net/wireless/ath/wil6210/interrupt.c |  6 +++---
 drivers/net/wireless/ath/wil6210/main.c      |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.c      | 30 ++++++++++++++--------------
 drivers/net/wireless/ath/wil6210/wil6210.h   |  4 ++--
 drivers/net/wireless/ath/wil6210/wmi.c       | 20 +++++++++++--------
 5 files changed, 33 insertions(+), 29 deletions(-)

-- 
2.1.4

