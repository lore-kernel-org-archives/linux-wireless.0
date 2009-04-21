Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49364 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbZDUOAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 10:00:53 -0400
Date: Tue, 21 Apr 2009 09:53:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Greg KH <greg@kroah.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>, dcbw@redhat.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090421135347.GH17805@tuxdriver.com> (sfid-20090421_160057_670934_5FBCCDAC)
References: <49E632A1.1050605@gmail.com> <20090415212103.GA5202@kroah.com> <200904182318.56512.IvDoorn@gmail.com> <20090420135940.GB3369@tuxdriver.com> <a32f33a40904210330w33a6cea6idf1756428e7560c7@mail.gmail.com> <a32f33a40904210542i24ed9f85x51bfd745635c9476@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a32f33a40904210542i24ed9f85x51bfd745635c9476@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 21, 2009 at 02:42:46PM +0200, Ivo Van Doorn wrote:
> On Tue, Apr 21, 2009 at 12:30 PM, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> > On Mon, Apr 20, 2009 at 3:59 PM, John W. Linville
> > <linville@tuxdriver.com> wrote:
> >> On Sat, Apr 18, 2009 at 11:18:56PM +0200, Ivo van Doorn wrote:
> >>> Hi,
> >>>
> >>> > > I hope rt2800pci/usb to be included *ASAP*, because rt2800usb supports
> >>> > > more than 1oo USB devices and rt2800pci is included in a lot of
> >>> > > laptops(ask Torvalds [1] [2])
> >>> > >
> >>> > > [1] http://marc.info/?l=linux-netdev&m=121799144422863&w=2
> >>> > > [2] http://marc.info/?l=linux-kernel&m=123187052023831&w=2
> >>> >
> >>> > That would be great to have in, what's keeping it from happening?
> >>>
> >>> In short: A stable workable driver.
> >>>
> >>> The rt2800usb driver is pretty far (at least on my testsetup), but
> >>> still has problems with transmitting frames immediately after
> >>> association.
> >>
> >> I read this as "it works, but some frames are lost immediately after
> >> association" -- is that right?
> >
> > It is not "Some frames" it is "All frames" you can't get a DHCP lease,
> > or use a static IP and try to do anything.
> 
> To clarify a bit, this behavior summarizes the first minute after association,
> after that all frames queued in the past minute are bursted out in a single shot
> and normal traffic is possible again.

Ah, well in that case I'd say let's get it into at least wireless-testing.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
