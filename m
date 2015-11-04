Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38637 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbbKDLxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 06:53:48 -0500
Received: by wmeg8 with SMTP id g8so39309202wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2015 03:53:47 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 0/4] update ath10k support for QCA9377 chips
Date: Wed,  4 Nov 2015 12:53:31 +0100
Message-Id: <1446638015-23310-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20151104_125352_209733_8A7CDD48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Clarifying the naming scheme for QCA9377 targets
* Adding the dev_id mathod (RFC) as a HW identification helper
* updating missing hw_params for 1.1 target

Bartosz Markowski (4):
  ath10k: fix the currently supported QCA9377 target version name
  ath10k: update missing hw_params of QCA9377 hw1.1
  ath10k: introduce dev_id to hw_params
  ath10k: add QCA9377 hw1.0 support

 drivers/net/wireless/ath/ath10k/core.c | 53 +++++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/hw.h   | 17 +++++++++--
 drivers/net/wireless/ath/ath10k/pci.c  |  8 ++---
 4 files changed, 67 insertions(+), 12 deletions(-)

-- 
2.1.2

