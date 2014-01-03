Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:51724 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaACLIx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jan 2014 06:08:53 -0500
Subject: [PATCH 0/3] ath10k: firmware dbglog and debug print events
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 03 Jan 2014 12:59:13 +0200
Message-ID: <20140103105718.13474.70922.stgit@potku.adurom.net> (sfid-20140103_120858_066025_ADC32C85)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are two new interfaces, dbglog and debug print events, to help with
firmware debugging on ath10k. Please review.

---

Kalle Valo (3):
      ath10k: handle WMI debug print events
      ath10k: add trace event for WMI_DEBUG_MESG_EVENTID
      ath10k: add debugfs file to control firmware dbglog


 drivers/net/wireless/ath/ath10k/core.h  |    2 +
 drivers/net/wireless/ath/ath10k/debug.c |   66 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/trace.h |   21 ++++++++
 drivers/net/wireless/ath/ath10k/wmi.c   |   79 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h   |   49 +++++++++++++++++++
 5 files changed, 213 insertions(+), 4 deletions(-)

