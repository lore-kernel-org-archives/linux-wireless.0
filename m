Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eta-ori.net ([91.121.142.51]:48338 "EHLO orion.eta-ori.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762422AbZE1Pi5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 11:38:57 -0400
Received: from [10.0.0.10] (p4FEDFC70.dip.t-dialin.net [79.237.252.112])
	by orion.eta-ori.net (Postfix) with ESMTPSA id 5DF7B48C9A2
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2009 17:29:54 +0200 (CEST)
Message-ID: <4A1EAEA7.4070208@impulze.org>
Date: Thu, 28 May 2009 17:32:55 +0200
From: Daniel Mierswa <impulze@impulze.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath5k: works only occasionaly
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i'm facing issues with ath5k and my laptop ever since i first installed
it, linux 2.6.24 or somewhere around there.
i get occasionaly associated and working wireless lan at home though any
attempt to access public wifi (university/schools/cafes) results in
"CTRL-EVENT-DISCONNECTED -- remove keys" or "noise floor calibration
timeout" errors from wpa_supplicant (don't worry i already tried every
wpa_supplicant version from 0.6.1 to trunk, whereas the newer ones even
with the -Dnl80211 option). sometimes wpa_supplicant associates me but
packets will just time out (dhcp, ping, etc) and it will disassociate me
shortly after that attempt, also tried using nohwcrypt=1 as module
parameter and different kernels (as of request in
#linux-wireless/Freenode) which didn't cause any effect at all.
as you can imagine it's hard to provide you with useful debug
information right now, since i'm at home but i'm thankful for any
suggestions and guides on how to give you more useful information than that.

-- 
Mierswa, Daniel

If you still don't like it, that's ok: that's why I'm boss. I simply
know better than you do.
               --- Linus Torvalds, comp.os.linux.advocacy, 1996/07/22
