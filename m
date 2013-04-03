Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:38784 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761863Ab3DCQct (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 12:32:49 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: siwu@hrz.tu-chemnitz.de, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [TESTING-QH 0/2] mac80211: tweaks for DFS testing
Date: Wed,  3 Apr 2013 18:32:37 +0200
Message-Id: <1365006759-16779-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20130403_183252_423680_22DF46CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For DFS testing only.

Simon Wunderlich (2):
  REMOVEME: shorten time for NOP and CAC
  REMOVEME: remove NO_IBSS and PASSIVE_SCAN from reg_can_beacon()

 include/net/cfg80211.h |    4 ++--
 net/wireless/chan.c    |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.7.4.1

