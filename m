Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:53902 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbaHGJNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 05:13:07 -0400
Received: by mail-we0-f170.google.com with SMTP id w62so3858692wes.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 02:13:06 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/6] ath10k: fixes 2014-08-07, part 1
Date: Thu,  7 Aug 2014 11:03:26 +0200
Message-Id: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com> (sfid-20140807_111316_563134_A0F00071)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is part 1 (of 3) of my patches. Split for
your reviewing pleasure.

This one is mostly non-functional (just cleanups)
except the removal of soc powersave.


Michal Kazior (6):
  ath10k: embed ar_pci inside ar
  ath10k: remove target soc ps code
  ath10k: remove pci features var
  ath10k: group some pci probing helpers
  ath10k: remove htc->stopped
  ath10k: move fw init print

 drivers/net/wireless/ath/ath10k/ce.c   |  68 +------
 drivers/net/wireless/ath/ath10k/core.c |  50 ++---
 drivers/net/wireless/ath/ath10k/core.h |   6 +-
 drivers/net/wireless/ath/ath10k/htc.c  |  16 --
 drivers/net/wireless/ath/ath10k/htc.h  |   5 +-
 drivers/net/wireless/ath/ath10k/mac.c  |   4 +-
 drivers/net/wireless/ath/ath10k/mac.h  |   2 +-
 drivers/net/wireless/ath/ath10k/pci.c  | 358 +++++++++++----------------------
 drivers/net/wireless/ath/ath10k/pci.h  |  78 ++-----
 9 files changed, 163 insertions(+), 424 deletions(-)

-- 
1.8.5.3

