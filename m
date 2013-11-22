Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53520 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab3KVNaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Nov 2013 08:30:19 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so506097eae.33
        for <linux-wireless@vger.kernel.org>; Fri, 22 Nov 2013 05:30:17 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/3] ath10k: fixes 2013-11-22
Date: Fri, 22 Nov 2013 14:26:56 +0100
Message-Id: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com> (sfid-20131122_143027_819737_62F48D35)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This has some fixes I've stacked in my local repo.
There are no dependencies between them.

Michal Kazior (3):
  ath10k: use nss provided by mac80211
  ath10k: implement sta_rc_update()
  ath10k: fix Tx status clearing

 drivers/net/wireless/ath/ath10k/mac.c  | 88 +++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/txrx.c |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.h  |  6 +++
 3 files changed, 93 insertions(+), 3 deletions(-)

-- 
1.8.4.rc3

