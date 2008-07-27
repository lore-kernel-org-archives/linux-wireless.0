Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:50014
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046AbYG0QVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 12:21:34 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: ath9k working, almost
Date: Sun, 27 Jul 2008 17:20:34 +0100
Cc: "Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <200807261742.15693.alistair@devzero.co.uk> <1217170761.2700.12.camel@localhost.localdomain> <43e72e890807270807k1a5967bfs1adf74f1a4d1e864@mail.gmail.com>
In-Reply-To: <43e72e890807270807k1a5967bfs1adf74f1a4d1e864@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807271720.34696.alistair@devzero.co.uk> (sfid-20080727_182138_305108_96AE8C88)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 27 July 2008 16:07:05 Luis R. Rodriguez wrote:
> On Sun, Jul 27, 2008 at 7:59 AM, Dan Williams <dcbw@redhat.com> wrote:
> > On Sat, 2008-07-26 at 17:42 +0100, Alistair John Strachan wrote:
> >> Hi,
> >>
> >> The newly announced ath9k driver works great on an AR5418 Core 2 Duo
> >> Macbook, WPA2-TKIP/AES et al all work fine. It would be good to see this
> >> driver in wireless-testing, it completely replaces madwifi for me. I
> >> used linux.git (2.6.26) + wireless-testing.git + my-wireless-testing.git
> >> with success.
> >>
> >> The only thing that I couldn't get working was the signal strength meter
> >> in knetworkmanager. The AP signal strength shows up in iwlist ath0
> >> scanning, but whatever NM uses doesn't seem to work. All is good with
> >> madwifi, by comparison.
> >>
> >> Any ideas? NM issue?
> >
> > The signal strength code in NM hasn't changed for quite a long time.
> > Chances are it's the driver not reporting correctly.  What's the
> > iwconfig output for while you're connected to your AP?
> >
> >  Link Quality=92/100  Signal level=-36 dBm  Noise level=-91 dBm
> >
> > That's the line I care about.
>
> Its definitely borked, we just have to fix it. Its on our TODO list,
> unless someone gets to it first.

This is probably an issue of not RTFM'ing (sorry), but are there documents 
enabling Joe User to contribute this kind of thing?

How much of the XXX fixups are you planning on doing yourself, and how many 
would you like help with?

-- 
Cheers,
Alistair.
