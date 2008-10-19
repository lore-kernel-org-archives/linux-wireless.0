Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:34592 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbYJSNAE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 09:00:04 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KrXt4-0007U1-Qo
	for linux-wireless@vger.kernel.org; Sun, 19 Oct 2008 13:00:02 +0000
Received: from 81.214.144.189 ([81.214.144.189])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 19 Oct 2008 13:00:02 +0000
Received: from kormetin by 81.214.144.189 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 19 Oct 2008 13:00:02 +0000
To: linux-wireless@vger.kernel.org
From: metin <kormetin@gmail.com>
Subject: Re: B43 randomly and silently dropping connections...
Date: Sun, 19 Oct 2008 15:53:27 +0300
Message-ID: <gdfak8$cng$1@ger.gmane.org> (sfid-20081019_150018_716257_A403AF86)
References: <200810161959.43084.mcbrides9@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <200810161959.43084.mcbrides9@comcast.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes I can confirm this problem.
I have bcm4318 card and my connection frequently and unexpectidely is 
dropping with b43 (I had no problem with bcm43xx module). It did not 
differ at all which firmware I used.
dmesg gives:

b43-phy1: Loading firmware version 410.2160 (2007-05-26 15:32:10)
Registered led device: b43-phy1::tx
Registered led device: b43-phy1::rx
Registered led device: b43-phy1::radio
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: deauthenticating by local choice (reason=3)
input: b43-phy1 as /devices/virtual/input/input10
b43-phy1: Loading firmware version 410.2160 (2007-05-26 15:32:10)
Registered led device: b43-phy1::tx
Registered led device: b43-phy1::rx
Registered led device: b43-phy1::radio
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: authenticate with AP 00:73:05:10:a0:84
wlan0: authenticated
wlan0: associate with AP 00:73:05:10:a0:84
wlan0: RX AssocResp from 00:73:05:10:a0:84 (capab=0x471 status=0 aid=2)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present

...
wlan0: No ProbeResp from current AP 00:73:05:10:a0:84 - assume out of range
wlan0: authenticate with AP 00:73:05:10:a0:84
wlan0: authenticate with AP 00:73:05:10:a0:84
wlan0: authenticate with AP 00:73:05:10:a0:84
wlan0: authenticate with AP 00:73:05:10:a0:84
wlan0: authentication with AP 00:73:05:10:a0:84 timed out

Please help...

