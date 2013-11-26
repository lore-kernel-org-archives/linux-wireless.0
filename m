Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:63339 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab3KZOKo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 09:10:44 -0500
Received: by mail-ea0-f169.google.com with SMTP id l9so3548444eaj.14
        for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 06:10:43 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/3] ath10k: fixes 2013-11-22
Date: Tue, 26 Nov 2013 14:57:37 +0100
Message-Id: <1385474260-22385-1-git-send-email-michal.kazior@tieto.com> (sfid-20131126_151052_056547_0A33C95D)
In-Reply-To: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com>
References: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This has some fixes I've stacked in my local repo.
There are no dependencies between them.

v2:
 * refined commit messages

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

