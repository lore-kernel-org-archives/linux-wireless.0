Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:38916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755166AbYJEW7d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 18:59:33 -0400
Date: Sun, 5 Oct 2008 15:57:57 -0700
From: Greg KH <greg@kroah.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Kalle Valo <kalle.valo@iki.fi>, proski@gnu.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: at76_usb driver status
Message-ID: <20081005225757.GA22398@kroah.com> (sfid-20081006_005945_135660_EBAFA3E6)
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com> <20081005061603.GB28533@kroah.com> <1223188872.11272.87.camel@violet.holtmann.net> <20081005151429.GB20764@kroah.com> <1223223426.11272.101.camel@violet.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223223426.11272.101.camel@violet.holtmann.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 05, 2008 at 06:17:06PM +0200, Marcel Holtmann wrote:
> Hi Greg,
> 
> > > > > > In my quest to suck drivers into drivers/staging/ I noticed that the
> > > > > > at76_usb driver is being shipped by both Fedora and Ubuntu in their
> > > > > > kernels.
> > > > > 
> > > > > Yes, that's the original at76_usb driver which has it's own 802.11
> > > > > stack. Pavel Rosking was the maintainer of that driver. Based on the
> > > > > feedback in linux-wireless I then started porting the driver to use
> > > > > mac80211. 
> > > > > 
> > > > > (Maybe I should have renamed the port to something else than at76_usb
> > > > > because having two different drivers with the same name creates
> > > > > confusion.)
> > > > > 
> > > > > > So I was wondering what the status of this driver is, and if I
> > > > > > could/should add it to drivers/staging/?
> > > > > 
> > > > > The original at76_usb is working quite well, but it's unacceptable for
> > > > > the mainline because we cannot have two 802.11 stacks in kernel.
> > > > 
> > > > I understand this, but for the issue of the drivers/staging/ tree, it's
> > > > ok for us to have as many 802.11 stacks in the kernel as we can cram in
> > > > there :)
> > > 
> > > did you start working for Ubuntu now ;)
> > 
> > Heh, no, I'm just, to quote Linux, now the "Maintainer of Crap".  See
> > the lwn.net summary of the kernel summit for details :)
> 
> I was mainly referring to Kyle from OLS a year ago ;)

Doh, I forgot about that joke!

sorry, was slow this morning...

greg k-h
