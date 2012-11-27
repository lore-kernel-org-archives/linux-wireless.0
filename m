Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:32770 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab2K0SvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 13:51:13 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] Allow to set WMM parameters in IBSS mode
Date: Tue, 27 Nov 2012 19:50:30 +0100
Message-Id: <1354042232-32428-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121127_195118_467301_DA070A6B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches for mac80211 and iw allow to manually set WMM parameters
(cw_min/max, AIFS, TXOP) in IBSS networks. These are only configured on
the station where this is called.

Simon Wunderlich (1):
  nl80211: allow ad-hoc to set WMM parameters from outside

 net/wireless/nl80211.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.7.10.4

