Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s19.bay0.hotmail.com ([65.54.246.219]:29323 "EHLO
	bay0-omc3-s19.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791AbYIHARi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 20:17:38 -0400
Message-ID: <BAY118-W465E743CF36E2CD439D2CEDB550@phx.gbl> (sfid-20080908_021742_662171_6E276B97)
From: Greg White <pcguy11@live.com>
To: =?iso-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: rt2x00 and packet injection
Date: Sun, 7 Sep 2008 19:17:37 -0500
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> On Sat, Sep 6, 2008 at 9:37 PM, Greg wrote:
>> I tried aircrack-ng and 2.6.27-rc3 and the two don't want to work 
>>together.  Yes I dowloaded and compiled iw and libnl.  I have to use the 
>>driver from http://homepages.tu-darmstadt.de/~p_larbig/wlan/ to get 
>>aircrack-ng to work right.  Any suggestions?
>>
>> Thanks,
>
> There is another requirement to use aircrack-ng/aireplay-ng (or any
> other osdep-based injector) with a mac80211-based driver: you must use
> the latest version (1.0-rc1 or newer) of aircrack-ng. Also, the
> monitor interface (mon0) must be created with airmon-ng - some drivers
> will refuse to inject on wlan0, even if it's set to monitor mode. In
> addition, the interfaces must always be on the same channel (as there
> is only 1 radio), so it's important that both interfaces remain on the
> desired channel.
>
> BTW which sub-driver are you trying to use? rt73usb?

I am using aircrack-ng 1.0 rc1 rev 1085 with an Edimax USB wireless card.  Yes rt73usb is what I am trying to use.

Thanks,

_________________________________________________________________
See how Windows connects the people, information, and fun that are part of your life.
http://clk.atdmt.com/MRT/go/msnnkwxp1020093175mrt/direct/01/