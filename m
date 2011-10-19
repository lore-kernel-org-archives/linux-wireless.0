Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35852 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab1JSAiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 20:38:16 -0400
From: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Rishi Panjwani <rpanjwan@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Implement support for listen interval from userspace
Date: Tue, 18 Oct 2011 17:36:30 -0700
Message-ID: <1318984591-10037-1-git-send-email-rpanjwan@qca.qualcomm.com> (sfid-20111019_023818_901138_96C508FF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch allows modification of listen interval thereby allowing change 
in sleep/awake cycle causing change in power consumption numbers.

Rishi Panjwani (1):
  ath6kl: Implement support for listen interval from userspace

 drivers/net/wireless/ath/ath6kl/debug.c |   50 +++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

