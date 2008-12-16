Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36971 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbYLPRuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 12:50:22 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 09:50:22 -0800
Date: Tue, 16 Dec 2008 01:50:39 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Dan Williams <dcbw@redhat.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH,RFC] initial mwl8k driver for marvell topdog wireless
Message-ID: <20081216095039.GA6358@tesla> (sfid-20081216_185026_996217_04C1CEC6)
References: <20081216025542.GO18056@xi.wantstofly.org> <1229443806.7307.34.camel@localhost.localdomain> <20081216161658.GC3636@tuxdriver.com> <1229449041.7307.49.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1229449041.7307.49.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 16, 2008 at 09:37:21AM -0800, Dan Williams wrote:
> On Tue, 2008-12-16 at 11:16 -0500, John W. Linville wrote:
> > On Tue, Dec 16, 2008 at 11:10:06AM -0500, Dan Williams wrote:
> > > On Tue, 2008-12-16 at 03:55 +0100, Lennert Buytenhek wrote:
> > > > Hi all,
> > > >
> > > > Attached is an initial version of the mwl8k driver for Marvell 88w8xxx
> > > > PCI/PCIe wireless parts (against 2.6.27.1).  This version was written
> > > > and tested against the 88w8687 (802.11b/g), but it shouldn't be hard to
> > > > extend the support to other parts in the 8xxx series, since the firmware
> > > > interface is very similar between parts.
> > > >
> > > > There's an occasional timeout warning with mwl8k_stop(), and hardware
> > > > crypto is still a work-in-progress, but other than that it looks pretty
> > > > stable.
> > > >
> > > > Feedback appreciated!
> > >
> > > Oooh, thanks for the Christmas present.  Just in time for the holidays.
> > > Is there a git repo somewhere that we could all base off of, so we don't
> > > have to deal with patches to patches to patches until it gets into
> > > wireless-testing?
> >
> > I wouldn't worry too much about that.  The better questions is where
> > do we get firmware?
> 
> I believe I can post it.  Marvell recently changed the license terms on
> at least some of their firmware to be comparable to other freely
> available firmware (like Intel's).  Unfortunately you must have an
> extranet account to get it (they are working on fixing this too) but
> once you have it, the firmware blobs themselves are under a nice
> license.  I'll try to get something together today.

The right thing to do (tm) would be to post the firmware along with a
friendly license by the vendor to the linux-firmware git tree.

Lennert is this possible?

  Luis
