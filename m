Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16279 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1JTWgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 18:36:11 -0400
From: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Rishi Panjwani <rpanjwan@qca.qualcomm.com>
Subject: [PATCH v2] ath6kl: Implement support for listen interval from userspace
Date: Thu, 20 Oct 2011 15:35:10 -0700
Message-ID: <1319150111-5647-1-git-send-email-rpanjwan@qca.qualcomm.com> (sfid-20111021_003619_708260_B077A4F6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch allows modification of listen interval thereby allowing change
in sleep/awake cycle causing change in power consumption numbers.

Rishi Panjwani (1):
  ath6kl: Implement support for listen interval from userspace

 drivers/net/wireless/ath/ath6kl/debug.c |   60 +++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

