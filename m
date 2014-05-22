Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:59177 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaEVOTp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:19:45 -0400
Received: by mail-ee0-f52.google.com with SMTP id e53so2747438eek.39
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 07:19:44 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: async pci probing
Date: Thu, 22 May 2014 16:12:33 +0200
Message-Id: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com> (sfid-20140522_161950_560992_71509766)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Recently I've tried to built ath10k into kernel.
Thus I've discovered it doesn't play nice.

Are there any gotchas I should be aware of and
might've missed while changing this sort of thing?


Michal Kazior (2):
  ath10k: relocate core create/destroy functions
  ath10k: make core registering async

 drivers/net/wireless/ath/ath10k/core.c | 170 ++++++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/core.h |   2 +
 drivers/net/wireless/ath/ath10k/pci.c  |   2 -
 3 files changed, 96 insertions(+), 78 deletions(-)

-- 
1.8.5.3

