Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:55963 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYKXMBf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 07:01:35 -0500
Received: from math.ut.ee (math.ut.ee [193.40.36.2])
	by smtp2.it.da.ut.ee (Postfix) with ESMTP id 5822A73D57E
	for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 14:01:32 +0200 (EET)
Received: from localhost (localhost [127.0.0.1])
	by math.ut.ee (Postfix) with ESMTP id 3F6FBFD79B
	for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 14:01:32 +0200 (EET)
Date: Mon, 24 Nov 2008 14:01:32 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: linux-wireless@vger.kernel.org
Subject: RT2500 instability
Message-ID: <Pine.SOC.4.64.0811241354220.10894@math.ut.ee> (sfid-20081124_130157_509417_8CDC8BC5)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This actually a longstanding problem - I have never gottenr rt2x00 
driver to work reliably. It looks like it mostly works but often 
deauthenticates like in dmesg below. I have nerver had time to look more 
closely into it since when I'm using WiFi it's usually not a good time 
for debugging. Using 2.6.21 with Ralink vendor driver just works, so I 
boot into 2.6.21 when I'm in WiFi area. Using pc-card rt2500 from 
Canyon.

What is the best way to debug this?

ADDRCONF(NETDEV_UP): eth1: link is not ready
eth1: authenticate with AP 00:1f:6c:ab:db:40
eth1: authenticate with AP 00:1f:6c:ab:db:40
eth1: authenticate with AP 00:1f:6c:ab:db:40
eth1: authentication with AP 00:1f:6c:ab:db:40 timed out
eth1: authenticate with AP 00:1f:6c:ab:db:40
eth1: authenticate with AP 00:1f:6c:ab:db:40
eth1: authenticate with AP 00:1f:6c:ab:db:40
eth1: authentication with AP 00:1f:6c:ab:db:40 timed out
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX AssocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 aid=13)
eth1: associated
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
eth1: no IPv6 routers present
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=13)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=13)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=13)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=13)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=13)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=13)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=13)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=13)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=13)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=13)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=13)
eth1: associated
eth1: No ProbeResp from current AP 00:1f:9e:28:d9:30 - assume out of 
range
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authentication with AP 00:1f:9e:28:d9:30 timed out
eth1: authenticate with AP 00:1f:6c:ab:db:40
eth1: authenticate with AP 00:1f:6c:ab:db:40
eth1: authenticate with AP 00:1f:6c:ab:db:40
eth1: authentication with AP 00:1f:6c:ab:db:40 timed out
eth1: authenticate with AP 00:1f:6c:ab:db:40
eth1: authenticate with AP 00:1f:6c:ab:db:40
eth1: authenticate with AP 00:1f:6c:ab:db:40
eth1: authentication with AP 00:1f:6c:ab:db:40 timed out
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=18)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=18)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=18)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authentication with AP 00:1f:9e:28:d9:30 timed out
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 aid=9)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 
aid=17)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 aid=9)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 aid=9)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 aid=9)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 aid=9)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 aid=9)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 aid=9)
eth1: associated
eth1: deauthenticated
eth1: authenticate with AP 00:1f:9e:28:d9:30
eth1: authenticated
eth1: associate with AP 00:1f:9e:28:d9:30
eth1: RX ReassocResp from 00:1f:9e:28:d9:30 (capab=0x421 status=0 aid=9)
eth1: associated
eth1: deauthenticated


-- 
Meelis Roos (mroos@linux.ee)
