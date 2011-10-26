Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19457 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab1JZA2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 20:28:49 -0400
From: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Rishi Panjwani <rpanjwan@qca.qualcomm.com>
Subject: [PATCH v3] ath6kl: Implement support for listen interval from userspace
Date: Tue, 25 Oct 2011 17:26:28 -0700
Message-ID: <1319588789-17632-1-git-send-email-rpanjwan@qca.qualcomm.com> (sfid-20111026_022852_081368_2E2D86CF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch allows modification of listen interval thereby allowing change
in sleep/awake cycle causing change in power consumption numbers.

Rishi Panjwani (1):
  ath6kl: Implement support for listen interval from userspace

 drivers/net/wireless/ath/ath6kl/debug.c |   63 +++++++++++++++++++++++++++++++
 1 files changed, 63 insertions(+), 0 deletions(-)

