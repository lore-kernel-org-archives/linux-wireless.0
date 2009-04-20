Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40675 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbZDTOAv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 10:00:51 -0400
Date: Mon, 20 Apr 2009 09:59:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Greg KH <greg@kroah.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>, dcbw@redhat.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090420135940.GB3369@tuxdriver.com> (sfid-20090420_160055_544720_8A9084EA)
References: <49E632A1.1050605@gmail.com> <20090415212103.GA5202@kroah.com> <200904182318.56512.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200904182318.56512.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 18, 2009 at 11:18:56PM +0200, Ivo van Doorn wrote:
> Hi,
> 
> > > I hope rt2800pci/usb to be included *ASAP*, because rt2800usb supports
> > > more than 1oo USB devices and rt2800pci is included in a lot of
> > > laptops(ask Torvalds [1] [2])
> > > 
> > > [1] http://marc.info/?l=linux-netdev&m=121799144422863&w=2
> > > [2] http://marc.info/?l=linux-kernel&m=123187052023831&w=2
> > 
> > That would be great to have in, what's keeping it from happening?
> 
> In short: A stable workable driver.
> 
> The rt2800usb driver is pretty far (at least on my testsetup), but
> still has problems with transmitting frames immediately after
> association.

I read this as "it works, but some frames are lost immediately after
association" -- is that right?  FWIW, this sounds good enough to me
to get it into the mainline kernel.  _Please_ submit the rt2800usb
driver for wireless-testing/linux-next ASAP!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
