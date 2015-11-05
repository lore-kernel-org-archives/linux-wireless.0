Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36217 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030329AbbKEIvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 03:51:31 -0500
Received: by lbblt2 with SMTP id lt2so11409120lbb.3
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2015 00:51:29 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v2 0/4] update ath10k support for QCA9377 chips
Date: Thu,  5 Nov 2015 09:50:39 +0100
Message-Id: <1446713443-22542-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20151105_095134_656034_8FE1C7B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Clarifying the naming scheme for QCA9377 targets
* Adding the dev_id mathod (RFC) as a HW identification helper
* updating missing hw_params for 1.1 target

---

Notes:
  v2:
   * rebase
   * fix the whitespace mess in patch 4/4 [Kalle]

Bartosz Markowski (4):
  ath10k: fix the currently supported QCA9377 target version name
  ath10k: update missing hw_params of QCA9377 hw1.1
  ath10k: introduce dev_id to hw_params
  ath10k: add QCA9377 hw1.0 support

 drivers/net/wireless/ath/ath10k/core.c | 49 ++++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/hw.h   | 17 ++++++++++--
 drivers/net/wireless/ath/ath10k/pci.c  |  8 ++----
 4 files changed, 65 insertions(+), 10 deletions(-)

-- 
2.1.2

