Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:57193 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384AbYJSQvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 12:51:09 -0400
Message-ID: <48FB6577.4010406@lwfinger.net> (sfid-20081019_185113_182606_9B851987)
Date: Sun, 19 Oct 2008 09:51:03 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: metin <kormetin@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: B43 randomly and silently dropping connections...
References: <200810161959.43084.mcbrides9@comcast.net> <gdfak8$cng$1@ger.gmane.org>
In-Reply-To: <gdfak8$cng$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

metin wrote:
> Yes I can confirm this problem.
> I have bcm4318 card and my connection frequently and unexpectidely is
> dropping with b43 (I had no problem with bcm43xx module). It did not
> differ at all which firmware I used.
> dmesg gives:
> 
> b43-phy1: Loading firmware version 410.2160 (2007-05-26 15:32:10)
> Registered led device: b43-phy1::tx
> Registered led device: b43-phy1::rx
> Registered led device: b43-phy1::radio
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> wlan0: deauthenticating by local choice (reason=3)
> input: b43-phy1 as /devices/virtual/input/input10
> b43-phy1: Loading firmware version 410.2160 (2007-05-26 15:32:10)
> Registered led device: b43-phy1::tx
> Registered led device: b43-phy1::rx
> Registered led device: b43-phy1::radio
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> wlan0: authenticate with AP 00:73:05:10:a0:84
> wlan0: authenticated
> wlan0: associate with AP 00:73:05:10:a0:84
> wlan0: RX AssocResp from 00:73:05:10:a0:84 (capab=0x471 status=0 aid=2)
> wlan0: associated
> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> wlan0: no IPv6 routers present
> 
> ...
> wlan0: No ProbeResp from current AP 00:73:05:10:a0:84 - assume out of range
> wlan0: authenticate with AP 00:73:05:10:a0:84
> wlan0: authenticate with AP 00:73:05:10:a0:84
> wlan0: authenticate with AP 00:73:05:10:a0:84
> wlan0: authenticate with AP 00:73:05:10:a0:84
> wlan0: authentication with AP 00:73:05:10:a0:84 timed out
> 
> Please help...

What kernel version? There have been a number of recent changes in mac80211 that
make connections a lot more robust. If you are not running 2.6.27, I suggest
getting it, or (even better) a copy of wireless-testing.

Larry
