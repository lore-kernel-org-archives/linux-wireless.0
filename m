Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:28953 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab2KZM3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 07:29:42 -0500
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <backports@vger.kernel.org>
Subject: [PATCH 0/3] Patches for compat-drivers/linux-3.6.y
Date: Mon, 26 Nov 2012 17:59:54 +0530
Message-ID: <1353932997-8051-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20121126_132945_466363_0D8F634D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches are for linux-3.6.y branch and has some
fixes for AR9565.

Bala Shanmugam (3):
  compat-drivers: Remove few cherry-pick patches
  compat-drivers: Add next-pending patches.
  compat-drivers: Add a crap patch for AR9565

 ...005-ath9k-Improve-PAN-profile-performance.patch |  141 ++++++++++++++++++++
 .../0088-cfg80211-fix-antenna-gain-handling.patch  |   39 ------
 ...tale-pointers-potentially-causing-access-.patch |   43 ------
 ...for-TID-only-in-BlockAcks-while-checking-.patch |   65 ---------
 ...x-signal-strength-noise-measurements-on-a.patch |    2 +-
 .../0002-ath9k-Fix-MCI-reset-in-BT-cal_req.patch   |   95 +++++++++++++
 ...mp-audio-profiles-on-weak-signal-strength.patch |  105 +++++++++++++++
 7 files changed, 342 insertions(+), 148 deletions(-)
 create mode 100644 crap/0005-ath9k-Improve-PAN-profile-performance.patch
 delete mode 100644 linux-next-cherry-picks/0088-cfg80211-fix-antenna-gain-handling.patch
 delete mode 100644 linux-next-cherry-picks/0093-ath9k-fix-stale-pointers-potentially-causing-access-.patch
 delete mode 100644 linux-next-cherry-picks/0119-ath9k-Test-for-TID-only-in-BlockAcks-while-checking-.patch
 create mode 100644 linux-next-pending/0002-ath9k-Fix-MCI-reset-in-BT-cal_req.patch
 create mode 100644 linux-next-pending/0003-ath9k-stomp-audio-profiles-on-weak-signal-strength.patch

-- 
1.7.4.1

