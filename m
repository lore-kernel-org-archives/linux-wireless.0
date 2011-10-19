Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50610 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab1JSAWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 20:22:07 -0400
From: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Rishi Panjwani <rpanjwan@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Implement support for background scan control from userspace
Date: Tue, 18 Oct 2011 17:20:05 -0700
Message-ID: <1318983606-8959-1-git-send-email-rpanjwan@qca.qualcomm.com> (sfid-20111019_022212_027929_9E4BC090)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The feature allows controlling background scan intervals

Rishi Panjwani (1):
 ath6kl: Implement support for listen interval from userspace

drivers/net/wireless/ath/ath6kl/debug.c |   34 +++++++++++++++++++++++++++++++
1 files changed, 34 insertions(+), 0 deletions(-)

