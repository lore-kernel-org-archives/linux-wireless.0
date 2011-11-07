Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45753 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab1KGPky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 10:40:54 -0500
Subject: Re: ifconfig down and mac80211 issue
From: Johannes Berg <johannes@sipsolutions.net>
To: voncken <cedric.voncken@acksys.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320677698.1687.13.camel@voncken-desktop> (sfid-20111107_161533_878983_7E7F3261)
References: <1320677698.1687.13.camel@voncken-desktop>
	 (sfid-20111107_161533_878983_7E7F3261)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 16:40:43 +0100
Message-ID: <1320680443.3993.45.camel@jlt3.sipsolutions.net> (sfid-20111107_164057_759864_F64BDC0C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-07 at 15:54 +0100, voncken wrote:
> Hi,
> 
>     I am currently trying to use rstp protocol (using rstpd ) over
> wireless interfaces (ath9k) and I've noticed some strange hostapd
> behaviour.
> 
>     Everything seems to work great with wired Ethernet devices.
> 
>     this is what I do : 
> 	- I have configured an AP (with hostapd), and it works perfectly
> (beacons were sent)
>     	- ifconfig wlanx down
> 	- ifconfig wlanx up
> 
>     after the ifconfig up, the wlanx does not send any beacons although
> clients are perfectly able to associate with (WPA-SUPPLICANT does an
> active scan).

You can't do that. If you set down everything is unconfigured. If you
need to take it down/up then you need to do that before you start
hostapd.

johannes

