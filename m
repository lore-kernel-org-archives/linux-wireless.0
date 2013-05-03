Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56086 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934031Ab3ECTyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 15:54:10 -0400
Received: from mailout-de.gmx.net ([10.1.76.16]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MEphU-1UoKcc2Z7C-00Fz7D for
 <linux-wireless@vger.kernel.org>; Fri, 03 May 2013 21:54:08 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	radiotap@NetBSD.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: Patches for STBC Standartisation
Date: Fri,  3 May 2013 21:53:52 +0200
Message-Id: <1367610836-3303-1-git-send-email-linux@rempel-privat.de> (sfid-20130503_215414_035108_E46048E4)
In-Reply-To: <1367527479.11375.19.camel@jlt4.sipsolutions.net>
References: <1367527479.11375.19.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are two series of patches. First are kernel patches
and ath9k driver patch.
Second, is patch for tcpdump.

All of them was tested for 1,2 and 3 stream scenarious.
Sinse i do not have hardware which can recive more than 1 STBC
stream, i did some hacks to to produce this kind of captures.

Oleksij Rempel (3):
  mac80211: add STBC flag for radiotap
  ath9k: remove useless flag conversation.
  ath9k: check for Rx-STBC flag and pass it to ieee80211


-- 
1.8.1.2

