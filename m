Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:55438 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab3E0J1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 05:27:50 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20899.9846.857204.903600@gargle.gargle.HOWL> (sfid-20130527_112753_663177_B9F24425)
Date: Mon, 27 May 2013 14:55:10 +0530
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] ath10k fixes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Patches to fix various 11ac issues.

Sujith

Sujith Manoharan (3):
  ath10k: Use VHT MCS map given by firmware
  ath10k: Calculate correct peer PHY mode for VHT
  ath10k: Fix bug in max. VHT A-MPDU size

 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 47 +++++++++++++++++++++-------------
 drivers/net/wireless/ath/ath10k/wmi.c  |  1 +
 3 files changed, 31 insertions(+), 18 deletions(-)

-- 
1.8.3

