Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:48953 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbbCAGUQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 01:20:16 -0500
Received: from [117.199.133.19] (port=11028 helo=sujith-pixel.localdomain)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YRxEc-002K5A-Fk
	for linux-wireless@vger.kernel.org; Sun, 01 Mar 2015 01:20:15 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/6] ath9k patches
Date: Sun,  1 Mar 2015 11:53:43 +0530
Message-Id: <1425191029-13667-1-git-send-email-sujith@msujith.org> (sfid-20150301_072028_733633_CB1A066B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

ath9k patches for -next.

Sujith Manoharan (6):
  ath9k: Remove useless return value check
  ath9k: Initialize MCI state correctly
  ath9k: Fix MCI scheme initialization
  ath9k: Fix wlan-active gpio for the AR9003 family
  ath9k: Handle timers for MCI
  ath9k: Fix issues in the main btcoex timer

 drivers/net/wireless/ath/ath9k/btcoex.c | 43 ++++++++++-----
 drivers/net/wireless/ath/ath9k/btcoex.h |  1 +
 drivers/net/wireless/ath/ath9k/gpio.c   | 95 +++++++++++++++++----------------
 3 files changed, 79 insertions(+), 60 deletions(-)

-- 
2.3.0

