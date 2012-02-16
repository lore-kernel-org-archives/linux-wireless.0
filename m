Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31021 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab2BPGVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 01:21:07 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20284.41019.830620.908735@gargle.gargle.HOWL> (sfid-20120216_072111_622178_199EFAD8)
Date: Thu, 16 Feb 2012 11:50:43 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v2 0/9] ath9k patches
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Here is a consolidated set of all the pending patches for ath9k,
rebased over current -wl. A couple of patches from the last series
have been dropped.

Sujith

Sujith Manoharan (9):
  ath9k: Remove unnecessary variable initialization
  ath9k: Merge wiphy and misc debugfs files
  ath9k: Add a debugfs file to display reset statistics
  ath9k: Prettify recv debugfs file output
  ath9k: Fix phyerr debug statistics
  ath9k: Remove unused initvals
  ath9k: Initialize NF values properly
  ath9k: Fix programming SYNTH4 for AR9462
  ath9k: Fix descriptor length for AR9462

 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |    6 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.h        |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   15 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |   17 +-
 .../net/wireless/ath/ath9k/ar9462_1p0_initvals.h   |  394 -----------------
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |  465 --------------------
 drivers/net/wireless/ath/ath9k/debug.c             |  373 +++++++----------
 7 files changed, 181 insertions(+), 1092 deletions(-)

-- 
1.7.9.1

