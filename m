Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:44436 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbbFKLGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 07:06:39 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.neratec.com (Postfix) with ESMTP id B52988E4A96
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 13:06:36 +0200 (CEST)
From: Matthias May <matthias.may@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: matthias.may@neratec.com
Subject: [PATCHv2 0/4] Handle minimum bandwidth for quarter and half rates
Date: Thu, 11 Jun 2015 13:06:27 +0200
Message-Id: <1434020791-16291-1-git-send-email-matthias.may@neratec.com> (sfid-20150611_130645_098062_A69632A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The goal of this patch series is to improve regulatory handling of quarter and half rates.

v2: Changes based on feedback by Johannes Berg.

Matthias May (4):
  cfg80211: handle minimum bandwidth for quarter and half rate
  ath: send minimum bandwidth to handle.
  brcm80211: send minimum bandwidth to handle
  rtlwifi: send minimum bandwidth to handle

 drivers/net/wireless/ath/regd.c                   |  3 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |  3 +-
 drivers/net/wireless/rtlwifi/regd.c               |  7 ++--
 include/net/cfg80211.h                            |  3 +-
 net/wireless/reg.c                                | 46 ++++++++++++++++++-----
 5 files changed, 47 insertions(+), 15 deletions(-)

-- 
2.1.4

