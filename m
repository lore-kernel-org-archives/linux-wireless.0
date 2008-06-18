Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from serv04.lahn.de ([213.239.197.57]:45600 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbYFRIPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 04:15:21 -0400
Received: from localhost (localhost [127.0.0.1])
	by elektra.leun.net (8.13.8/8.13.8/SuSE Linux 0.8) with ESMTP id m5I7gDk6022369
	for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2008 09:42:13 +0200
Date: Wed, 18 Jun 2008 09:42:13 +0200
From: Michael Leun <linux-wireless@newton.leun.net>
To: linux-wireless@vger.kernel.org
Subject: compat wireless, i3945, tcpdump: Machine freezes
Message-ID: <20080618094213.5abd2fbd@localhost> (sfid-20080618_101555_136851_7E33BCBE)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I downloaded compat-wireless-2008-06-18, built it, loaded cfg80211.ko,
mac80211.ko, iwl3945.ko, associated to an ap, started "tcpdump -i wlan0
-n" and the machine mostly freezed.

Mostly means keyboard does not work, no disk-access, no network but
mouse still works.

This is reproducable, freeze happens instantly after starting tcpdump
(if a ping runs while I start tcpdump I see one Packet in the output of
tcpdump, then machine is frozen).

I've had that with some older versions of compat-wireless also.

I've a Thinkpad Z61m.

-- 
MfG,

Michael Leun

