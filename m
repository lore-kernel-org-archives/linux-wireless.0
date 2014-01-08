Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:18263 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbaAHJvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 04:51:07 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 0/3] wil6210 patches
Date: Wed, 8 Jan 2014 11:50:46 +0200
Message-ID: <1389174649-14077-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140108_105113_837751_A7EE1DBC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Small set of ready to integration patches.

- fix for IPv6 (Fix IP version indication for Tx csum offload)
- performance improvements (2 other patches)

Vladimir Kondratiev (3):
  wil6210: interrupt moderation
  wil6210: Fix IP version indication for Tx csum offload
  wil6210: prefetch head of packet

 drivers/net/wireless/ath/wil6210/interrupt.c | 13 +++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.c      |  8 ++++++--
 drivers/net/wireless/ath/wil6210/wil6210.h   |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

-- 
1.8.3.2

