Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39432 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbaLJMoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 07:44:19 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so11076680wiv.17
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2014 04:44:18 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/5] ath10k: a bunch of STA-related fixes
Date: Wed, 10 Dec 2014 13:31:49 +0100
Message-Id: <1418214714-29689-1-git-send-email-michal.kazior@tieto.com> (sfid-20141210_134423_324465_FCF08703)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Michal Kazior (5):
  ath10k: improve 11b coex
  ath10k: fix STA u-APSD
  ath10k: prevent invalid ps timeout config
  ath10k: enable per-vif sta powersave
  ath10k: advertise p2p dev support

 drivers/net/wireless/ath/ath10k/core.c |  6 ---
 drivers/net/wireless/ath/ath10k/mac.c  | 89 ++++++++++++++++++++++++++++------
 2 files changed, 74 insertions(+), 21 deletions(-)

-- 
1.8.5.3

