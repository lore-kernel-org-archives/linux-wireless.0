Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:24236 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbXLIICh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 03:02:37 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2567939wah
        for <linux-wireless@vger.kernel.org>; Sun, 09 Dec 2007 00:02:37 -0800 (PST)
Message-ID: <5b9417770712090002p6c53a1b8i49259945e4389588@mail.gmail.com> (sfid-20071209_080239_894960_94243526)
Date: Sun, 9 Dec 2007 02:02:37 -0600
From: "John H." <mistamaila@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: b43 continues to have issue with APs at times
Cc: bcm43xx-dev@lists.berlios.de, "Michael Buesch" <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org,
	"Larry Finger" <larry.finger@lwfinger.net>
In-Reply-To: <200712082209.57069.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <5b9417770712081222y4f0ab1va51910faf16fb068@mail.gmail.com>
	 <200712082135.11685.mb@bu3sch.de> <200712082209.57069.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

yes.  not until i reboot the AP, and this is with two different APs,
does it resolve.

My other problem, at least with this AP, is that although it is a G
device, i cannot get 54mb/s speed or anything close, with iwconfig
generally reporting 1mb/s.

In other words, I cannot use mythtv over a network which I was able to
do with ndiswrapper.

On Dec 8, 2007 3:09 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, 8 of December 2007, Michael Buesch wrote:
> > On Saturday 08 December 2007 21:22:37 John H. wrote:
> > > I have this problem at two different locations with two different
> > > access points.  2.6.23.1 kernel, and sometimes until I actually power
> > > down the AP and restart it, wpa_supplicant and such just times out on
> > > the AP.
> > >
> > > Any ideas?
>
> Have you tried to change the distance from the AP (like moving closer to it
> when the wpa_supplicant is appearing to have problems)?
>
> Rafael
>
