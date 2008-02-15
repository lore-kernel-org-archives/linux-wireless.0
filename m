Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc1-s23.bay0.hotmail.com ([65.54.246.95]:33582 "EHLO
	bay0-omc1-s23.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753957AbYBOVxR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 16:53:17 -0500
Message-ID: <BAY101-W21EEABECED4579CBF99102C8260@phx.gbl> (sfid-20080215_215324_600955_083B8030)
From: Adam Turk <bofh1234@hotmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: RE: kernel 2.6.25-rc1 and no /dev/rt73usb
Date: Fri, 15 Feb 2008 16:53:16 -0500
In-Reply-To: <200802152224.34055.IvDoorn@gmail.com>
References: <BAY101-W101FB386E1EF7402881964C8260@phx.gbl>
 <200802152146.06364.IvDoorn@gmail.com>
 <BAY101-W378CC14C633084DBF091A6C8260@phx.gbl>
 <200802152224.34055.IvDoorn@gmail.com>
Content-Type: text/plain; charset=iso-8859-1
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> The driver I was using before had the interface name of rt73. When I=
 see
>> usbcore: registered new interface driver rt73usb
>
> Seriously, I wonder with what driver you managed to pull that off.
> As far as I know there is no rt73 driver that registers an interface =
called rt73.
> Neither the Ralink drivers, the rt73 legacy driver or the rt73usb dri=
ver ever
> did such a thing.
>
> Granted the name did change. The Ralink driver and early legacy drive=
rs
> did create the interface with the name "rausb", this is still not the=
 same
> as "rt73".
>
> Additionally:
>> usbcore: registered new interface driver rt73usb
>
> Using a different rt73 driver would also produce this line (replacing=
 rt73usb
> with rt73 or whatever the name of the driver was).
> But like I said earlier, I know of no rt73 driver that registered a n=
etwork
> interface named rt73. It is either "wlan" or "rausb". Unless off cour=
se you
> edited the /etc/modprobe.conf file to load the driver with the rt73 i=
nterface name,
> but that can be considered "user configuration".

Ok.  Upon further investigation the name was rausb0.  The rt73 was setu=
p in /etc/modprobe.conf.  So is the name going to be wlan0 from now on?

The short version:
I am stuck on a project where the last guy setup everything, didn't doc=
ument anything, and left.  I am now trying to figure all of this stuff =
out.  I am stuck using Slackware.  A hybrid of 9 and 10.  I am a Fedora=
 user so very little is where I except it to be.  I am trying to figure=
 everything out and move to centos with a 2.6.24.x kernel (needed for t=
he new hardware this monstrosity of an application is moving to). =20

Thanks,

_________________________________________________________________
Climb to the top of the charts!=A0Play the word scramble challenge with=
 star power.
http://club.live.com/star_shuffle.aspx?icid=3Dstarshuffle_wlmailtextlin=
k_jan-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
