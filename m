Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36058 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbbGILIs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 07:08:48 -0400
Received: by lbbpo10 with SMTP id po10so72926560lbb.3
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 04:08:46 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/6] ath10k: random fixes 2015-07-09
Date: Thu,  9 Jul 2015 13:08:33 +0200
Message-Id: <1436440119-30231-1-git-send-email-michal.kazior@tieto.com> (sfid-20150709_130851_672163_D96E1B6E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've done most of the patches while testing P2P
but they aren't limited to that scope.

There are no inter-dependencies within the patchset
so single patches should be easily cherry-pickable
in case, e.g. some patches raise concerns or are
decided to be dropped during review.


Michal Kazior (6):
  ath10k: don't set cck/ofdm scan flags
  ath10k: limit multi-vif ps more aggresivelly
  ath10k: fix hw roc expiration notifcation
  ath10k: update vdev ps state on start
  ath10k: fix per-vif queue locking
  ath10k: tweak interface combinations

 drivers/net/wireless/ath/ath10k/core.h    |   1 +
 drivers/net/wireless/ath/ath10k/mac.c     | 115 ++++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/mac.h     |   6 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  32 +++++++--
 drivers/net/wireless/ath/ath10k/wmi.c     |   1 -
 5 files changed, 99 insertions(+), 56 deletions(-)

-- 
2.1.4

