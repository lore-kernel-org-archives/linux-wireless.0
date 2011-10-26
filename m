Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13189 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab1JZCwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 22:52:38 -0400
From: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Rishi Panjwani <rpanjwan@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Implement support for power parameter control from userspace
Date: Tue, 25 Oct 2011 19:52:40 -0700
Message-ID: <1319597561-20454-1-git-send-email-rpanjwan@qca.qualcomm.com> (sfid-20111026_045240_891441_679477F0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch allows modification of parameters which alter the sleep/awake mechanism like
ps-poll, thereby allowing control of power consumption

Rishi Panjwani (1):
  ath6kl: Implement support for power parameter control from userspace

 drivers/net/wireless/ath/ath6kl/debug.c |   65 +++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)

