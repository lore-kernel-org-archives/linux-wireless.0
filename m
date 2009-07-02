Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52437 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZGBLBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 07:01:35 -0400
Received: by fxm18 with SMTP id 18so1399513fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2009 04:01:37 -0700 (PDT)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Insist on cfg80211 for new drivers?
Date: Thu, 2 Jul 2009 13:07:13 +0200
Cc: Greg KH <greg@kroah.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, Dave <kilroyd@googlemail.com>,
	Karl Relton <karllinuxtest.relton@ntlworld.com>,
	dwmw2@infradead.org, linux-wireless@vger.kernel.org
References: <1246396179.4949.76.camel@localhost> <20090701221359.GA2604@kroah.com> <1246486729.12994.176.camel@localhost.localdomain>
In-Reply-To: <1246486729.12994.176.camel@localhost.localdomain>
MIME-Version: 1.0
Message-Id: <200907021307.17719.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

On Thursday 02 July 2009 00:18:49 Marcel Holtmann wrote:
> Hi Greg,
> 
> > > > >> > That's really all I
> > > > >> > care about, I don't want another WEXT-based driver accepted; I want all
> > > > >> > the new ones using cfg80211.
> > > > >>
> > > > >> Now there is a discussion we should have had in Berlin...is it time
> > > > >> to insist on cfg80211-based configuration for all new drivers?
> > > > >
> > > > > there is really nothing much to discuss on this topic. The plan is to
> > > > > deprecate WEXT, that simple. So if the driver has no cfg80211 support,
> > > > > then it will not be included. Period.
> > > > >
> > > > > Send such drivers off to staging and let them have their 6 month.  Then
> > > > > we either remove them again or they got ported to cfg80211.
> > > > 
> > > > 6 months only in staging ? Is this a rule now for staging?
> > > 
> > > that is what Greg mentioned to me. If there is no activity for 6 month
> > > and the driver is not getting anywhere, he going to drop it.
> > 
> > That is "within reason".  If a driver is still needed there, I'l
> > probably keep it, and will take each one on a case-by-case basis.
> 
> what do you mean "within reason". If the driver is just sitting there
> and no effort in making in upstream ready it is doing clearly more harm
> than any good. And I am not talking about removing some kernel version
> details or typedefs or coding style. Drivers with missing cfg80211 need

Well, most of those drivers need a major cleanup before porting..	

> active porting. And it is not that hard. See the orinoco one for an
> example.

Could you please provide some more pointers here, I don't see any such
changes in linux-next yet and I'm very interested in seeing a practical
example of such conversion (thanks!).

> If we see developers committed to fixing it that is a different story,
> but a lot of drivers in staging are getting no attention all. So they
> are fully pointless and are not doing any good for Linux. We need to
> send the vendors a clear message that code drops of their crappy Windows
> code are not desired.

How's about sending a clear _positive_ message for a change?

Where one can find an up to date documentation for {mac,cfg,nl}80211 (not
just some random DocBook generated excerpts, I mean the real thing here,
with references to kernel versions when API changes were introduced, some
practical examples and exemplary drivers) and more importantly when one
can find the _porting_ guide for the older stacks?

Thanks,
Bart
