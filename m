Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53064 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbbCIUyn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 16:54:43 -0400
Received: from minime.bse ([77.20.123.72]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0MNq4h-1YODCl1uwt-007SKN for
 <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2015 21:54:40 +0100
Date: Mon, 9 Mar 2015 21:54:51 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Maximilian Engelhardt <maxi@daemonizer.de>
Subject: Re: BCM4313 & brcmsmac & 3.12: only semi-working?
Message-ID: <20150309205451.GA13884@minime.bse> (sfid-20150309_215451_757737_56C28350)
References: <53FDACD1.8090805@msgid.tls.msk.ru>
 <9234001.YBqfvtcJFx@fuchs>
 <5496E135.1@broadcom.com>
 <9062978.Vq0rTjKd5z@fuchs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9062978.Vq0rTjKd5z@fuchs>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Sun, Dec 21, 2014 at 06:34:24PM +0100, Maximilian Engelhardt wrote:
> On Sunday 21 December 2014 16:03:17 Arend van Spriel wrote:
> > On 12/21/14 15:24, Maximilian Engelhardt wrote:
> > > On Sunday 21 December 2014 15:13:50 Arend van Spriel wrote:
> > >> Thanks. It shows you have have the same bt-coex version as Michael. I am
> > >> not familiar with bluetooth side of things. Are you both using bluetooth
> > >> on 4313?
> > >> 
> > >> Regards,
> > >> Arend
> > > 
> > > I don't know. I think I have Bluetooth somehow enabled but I'm not really
> > > using it. I definitely don't have any Bluetooth devices connected. I could
> > > try to unload/disable Bluetooth it to see if it makes any difference.
> > 
> > That would be useful to know.
> > 
> 
> I did a test with all Bluetooth modules unloaded that I could find but 
> throughput was still very low (about 4 Mbit/s with brcmsmac, my atheros USB 
> stick archived about 110 Mbit/s).

any update on this issue?
One of my relatives would like to get rid of that Ralink wifi stick she
has been carrying around for 1.5 years now since the internal wifi in her
Thinkpad E130 suffers from this problem.

Best regards,

  Daniel
