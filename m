Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:49673 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbYJEGk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 02:40:59 -0400
Subject: Re: at76_usb driver status
From: Marcel Holtmann <marcel@holtmann.org>
To: Greg KH <greg@kroah.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, proski@gnu.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20081005061603.GB28533@kroah.com>
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com>
	 <20081005061603.GB28533@kroah.com>
Content-Type: text/plain
Date: Sun, 05 Oct 2008 08:41:12 +0200
Message-Id: <1223188872.11272.87.camel@violet.holtmann.net> (sfid-20081005_084115_280521_B2F1021A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

> > > In my quest to suck drivers into drivers/staging/ I noticed that the
> > > at76_usb driver is being shipped by both Fedora and Ubuntu in their
> > > kernels.
> > 
> > Yes, that's the original at76_usb driver which has it's own 802.11
> > stack. Pavel Rosking was the maintainer of that driver. Based on the
> > feedback in linux-wireless I then started porting the driver to use
> > mac80211. 
> > 
> > (Maybe I should have renamed the port to something else than at76_usb
> > because having two different drivers with the same name creates
> > confusion.)
> > 
> > > So I was wondering what the status of this driver is, and if I
> > > could/should add it to drivers/staging/?
> > 
> > The original at76_usb is working quite well, but it's unacceptable for
> > the mainline because we cannot have two 802.11 stacks in kernel.
> 
> I understand this, but for the issue of the drivers/staging/ tree, it's
> ok for us to have as many 802.11 stacks in the kernel as we can cram in
> there :)

did you start working for Ubuntu now ;)

Regards

Marcel


