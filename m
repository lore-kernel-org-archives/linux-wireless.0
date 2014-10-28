Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:55245 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaJ1JoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 05:44:02 -0400
Received: by mail-lb0-f176.google.com with SMTP id p9so241080lbv.35
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2014 02:44:00 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 0/4] ath10k: pci related fixes 2014-10-09
Date: Tue, 28 Oct 2014 10:32:04 +0100
Message-Id: <1414488728-31489-1-git-send-email-michal.kazior@tieto.com> (sfid-20141028_104415_623641_60188F80)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is a partial re-spin which includes the
not-yet-applied patches that fix/change warm
reset.

v3:
 * change CE ring cleanup (new patch #1)


Michal Kazior (4):
  ath10k: change ce ring cleanup logic
  ath10k: make warm reset a bit safer and faster
  ath10k: split reset logic from power up
  ath10k: don't reset chip on power_down

 drivers/net/wireless/ath/ath10k/ce.c  |   6 -
 drivers/net/wireless/ath/ath10k/pci.c | 345 +++++++++++++++++-----------------
 2 files changed, 176 insertions(+), 175 deletions(-)

-- 
1.8.5.3

