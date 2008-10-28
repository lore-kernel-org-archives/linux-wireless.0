Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:34544 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752147AbYJ1GMg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 02:12:36 -0400
Date: Mon, 27 Oct 2008 23:10:23 -0700
From: Greg KH <greg@kroah.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: rtl2860 driver in mainline?
Message-ID: <20081028061023.GA6568@kroah.com> (sfid-20081028_071244_444831_50EF28EF)
References: <20081028004915.GA3442@kroah.com> <a32f33a40810272248j5ee755ccoc8f6a8c8d5338cb8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a32f33a40810272248j5ee755ccoc8f6a8c8d5338cb8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 06:48:31AM +0100, Ivo Van Doorn wrote:
> Hi,
> 
> > So, on my quest to suck up every out-of-tree driver and get it into the
> > main kernel tree (drivers/staging/ to start with), I've been pointed at
> > the rtl2860 driver.
> 
> in that case make sure you include rt2870 on your list as well then. ;)

Do you have a pointer to it?

> > Does anyone know of a "cleaned up" version of this driver that is
> > newer/better than the one on ralink's web site?  I found the
> > 2008_0918_RT2860_Linux_STA_v1.8.0.0.tar.bz2 version there, and will
> > start with that if no one else has yet.
> 
> rt2800pci/rt2800usb development is in progress in the rt2x00.git
> experimental branch:
> http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=shortlog;h=experimental
> 
> The current status is that rt2800usb has working RX with some warnings
> regarding the
> RX signal, and a non functional TX. rt2800pci isn't complete yet.
> 
> So far progress has been very slow because of lack of time, so any help with the
> development of the drivers is welcome.

Is this a port of the tarball driver to the in-kernel wireless stack, or
starting over from scratch?

As it's not really working, do you mind if I just dump the tarball
driver into the staging tree for users to use now (hint, they already
are, the distros are shipping that driver as a kernel module package),
and then when this "real" driver is up and working properly, we can drop
the staging version?

thanks,

greg k-h
