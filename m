Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:44864 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab1ANHKH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 02:10:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PddnR-0002xX-Cl
	for linux-wireless@vger.kernel.org; Fri, 14 Jan 2011 08:10:05 +0100
Received: from 213-134-188-132.home.aster.pl ([213.134.188.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 08:10:05 +0100
Received: from dot by 213-134-188-132.home.aster.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 08:10:05 +0100
To: linux-wireless@vger.kernel.org
From: Tomasz <dot@poczta.fm>
Subject: ath9k  - cannot reconnect few meters from the antenna
Date: Thu, 13 Jan 2011 22:46:37 +0000 (UTC)
Message-ID: <loom.20110113T233025-142@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All
I've spend a lot of time on this issue and I cannot fix it, thus I am asking for
help
It looks like that:

I am running wireless access point based on:
Ubuntu 10.04  vmlinuz-2.6.32-27-generic
compat-wireless-2010-12-26
hostapd 0.7.3 (wpa/wpa2)
Dnsmasq version 2.52
Zotac Ion board
Minipcie card: ieee80211 phy0: Atheros AR9285 Rev:2
ath9k driver
Single antenna (but the behaviour with two antenna is similar)

Everything works perfectly fine when I am within the few meters from the antenna.
So the clients are connecting and I get 25 mbps data rates.
But if more then 10 meters from the antenna strange things are happening.
- If I am connected to the network and will walk away everything works perfect.
- But if i disconnect (disassociate) when I am away I cannot connect back. -
this also means I cannot connect when turning the notebook on :)
- if I go closer to antenna I am able to connect and while walking away the
connection seems perfectly stable ...

My first idea is the congestion control issue ... But maybe some will have the
better idea.


Regards
Tomasz



-- 
Tomek


