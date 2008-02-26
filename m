Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:51442 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760869AbYBZDhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 22:37:23 -0500
To: linux-wireless@vger.kernel.org
Subject: ath5k bf=xxx bf_skb=0 warnings
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 26 Feb 2008 04:37:21 +0100
Message-ID: <m3ve4cqtfy.fsf@maximus.localdomain> (sfid-20080226_033801_900453_64064F8D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Just wondering if "bf=xxx bf_skb=0" warnings printed to console
(ath5k/base.c:ath5k_beacon_send) are normal?

Linux ixp425 2.6.25-rc3 (ARM big-endian), AR5413

iwconfig wlan0 essid $ESSID mode ad-hoc channel $CH
iwconfig wlan0 key restricted $KEY
ifconfig wlan0 up

I understand sc->bbuf->skb is never set, the only possible place is
ath5k_beacon_update() but it's never called.
-- 
Krzysztof Halasa
