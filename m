Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:53743 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3KOJfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 04:35:07 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 0/5] ath9k patches
Date: Fri, 15 Nov 2013 15:00:22 +0530
Message-Id: <1384507827-16026-1-git-send-email-sujith@msujith.org> (sfid-20131115_103515_636587_E055CB0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This series attempts to cleanup the calibration code
in ath9k, which has accumulated lots of hacks and cruft.

There is still lots of work to be done in this area,
including fixes for new chips.

Please review.

Sujith

Sujith Manoharan (5):
  ath9k: Separate routines for PCOEM and SoC calibration
  ath9k: Remove RTT/MCI code from SoC calibration
  ath9k: Remove unnecessary check
  ath9k: Fix Carrier Leak calibration for SoC chips
  ath9k: Fix TX IQ calibration for SoC chips

 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 102 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   |   9 ++-
 2 files changed, 104 insertions(+), 7 deletions(-)

-- 
1.8.4.2

