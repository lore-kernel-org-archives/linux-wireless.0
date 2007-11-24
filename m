Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:22809 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbXKXB4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 20:56:10 -0500
Received: by rv-out-0910.google.com with SMTP id k20so2768104rvb
        for <linux-wireless@vger.kernel.org>; Fri, 23 Nov 2007 17:56:09 -0800 (PST)
Message-ID: <5b9417770711231756i68f6f9d0sdb7cff0b6bcf1896@mail.gmail.com> (sfid-20071124_015613_787775_338E425D)
Date: Fri, 23 Nov 2007 19:56:09 -0600
From: "John H." <mistamaila@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: timeout problems with certain APs and b43
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	bcm43xx-dev@lists.berlios.de,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, "Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <200711232321.58516.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <5b9417770711211135p65eab873leef65cd0e71452aa@mail.gmail.com>
	 <200711232258.25965.rjw@sisk.pl>
	 <1195855050.4149.179.camel@johannes.berg>
	 <200711232321.58516.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 23, 2007 4:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, 23 of November 2007, Johannes Berg wrote:
> >
>
> > > > > on certain APs, the internet works for a long time then stops, and I
> > > > > get authentication time outs, why?  It usually works again if I reset
> > > > > the AP itself, which i should not have to do and don't have to if in
> > > > > XP....
> > > >
> > > > > wlan0: Initial auth_alg=0
> > > > > wlan0: authenticate with AP 00:0f:66:53:3e:24
> > > > > wlan0: authenticate with AP 00:0f:66:53:3e:24
> > > > > wlan0: authenticate with AP 00:0f:66:53:3e:24
> > > > > wlan0: authentication with AP 00:0f:66:53:3e:24 timed out
> > > >
> > > > Does it help to reload the b43 module? I think I have seen this problem
> > > > before but always associated it with suspend/resume rather than a long
> > > > time elapsing, I also thought it was due to bad power recalibration.
> > >
> > > It seems that I can reproduce something similar on demand with an SMC wireless
> > > router by moving my box sufficiently far away from it. :-)
> >
> > Well, yeah, that's expected though, you lose signal at some point. Not
> > expected is that it happens without moving anything. Unless the
> > calibration code is wrong which wouldn't really surprise me either.
>
> In my case, everything works just fine when the box is 6 meters away from the
> AP (including a thick wall in between), but when I move it another 5-6 meters
> away from the AP, things break down ...
>
> I'd expect it to work at longer distances, but well. :-)
>
> Greetings,
> Rafael
>



wlan0     IEEE 802.11g  ESSID:"Network4Home"
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:0F:66:53:3E:24
          Bit Rate=1 Mb/s   Tx-Power=27 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Link Quality=68/100  Signal level=-58 dBm  Noise level=-69 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


I'd say 68/100 is a good signal strength.  I do use suspend/resume a
lot, but sometimes only a reboot of the laptop or the AP seems to get
it working normally again.
