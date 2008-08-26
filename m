Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:30709 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbYHZTy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2008 15:54:58 -0400
Received: by ey-out-2122.google.com with SMTP id 6so355703eyi.37
        for <linux-wireless@vger.kernel.org>; Tue, 26 Aug 2008 12:54:57 -0700 (PDT)
To: Forest Bond <forest@alittletooquiet.net>
Subject: Re: Are these Ralink chips supported?
Date: Tue, 26 Aug 2008 21:54:53 +0200
Cc: drago01 <drago01@gmail.com>, linux-wireless@vger.kernel.org
References: <20080805163234.GA22429@storm.local.network> <f6ca9fed0808261218w20334033h7eef71dba8400ac8@mail.gmail.com> <20080826192731.GC26037@storm.local.network>
In-Reply-To: <20080826192731.GC26037@storm.local.network>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808262154.53984.IvDoorn@gmail.com> (sfid-20080826_215502_530595_3AAE75C3)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 26 August 2008, Forest Bond wrote:
> Hi,
> 
> On Tue, Aug 26, 2008 at 09:18:59PM +0200, drago01 wrote:
> > On Tue, Aug 26, 2008 at 9:16 PM, Forest Bond <forest@alittletooquiet.net> wrote:
> > > On Wed, Aug 06, 2008 at 10:14:10AM +0200, Ivo van Doorn wrote:
> > >> On Tuesday 05 August 2008, Forest Bond wrote:
> > >> > I'm having a hard time figuring out if the following wireless chips are
> > >> > supported:
> > >> >
> > >> >  * RT2770 + RT2720
> > >>
> > >> I *think* this is the rt2870 driver. The in-kernel driver is under development
> > >
> > > Okay, the RT2870 driver from Ralink works with this device, but it seems to be a
> > > bit quirky:
> > >
> > >  * The device has to be brought up and down a few times before NetworkManager
> > >   sees it.  I'm not sure what NetworkManager is cueing off of.
> > >
> > >  * I was unable to get the thing to associate and come up using
> > >   iwconfig/ifconfig.  Might have been my range on that AP, though, since I was
> > >   shooting for an unencrypted network that is a not the closest network in my
> > >   building.
> > >
> > >  * Usual odd bits with vendor drivers like odd build system subtleties and
> > >   seemingly unnecessary configuration files (does anyone really care to fiddle
> > >   with those, or doesn't everyone just want things to work with the standard
> > >   configuration mechanisms like I do?).
> > >
> > > Is there an effort to move this driver in-tree?  The license is GPL.
> > 
> > Thats what Ivo is doing, port the driver to rt2x00 to make it
> > acceptable for merging.
> 
> Okay, sorry if I misunderstood.  Is this driver usable and, if so, where can the
> code be found?

I'm still struggling with the RX part. Code can be found at:
http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=shortlog;h=experimental

Ivo
