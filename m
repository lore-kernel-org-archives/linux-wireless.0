Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:42954 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab3FKIou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 04:44:50 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 0/2] mac80211 fixes
Date: Tue, 11 Jun 2013 10:44:38 +0200
Message-Id: <1370940280-7876-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130611_104457_353797_C4232FB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are two small mac80211 fixes:
 * I've been seeing a warning when doing DFS tests, which was triggered
   by aborting the CAC when killing hostapd
 * the rate control fix was sent as part of the v3 series of
   "Add support for 5 and 10 MHz channels", but since it's an trivial
   yet important fix I'm adding it to this series too.

Cheers,
	Simon

Simon Wunderlich (2):
  mac80211: abort CAC in stop_ap()
  mac80211: Fix rate control mask matching call

 net/mac80211/cfg.c  |    6 ++++++
 net/mac80211/rate.c |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

-- 
1.7.10.4

