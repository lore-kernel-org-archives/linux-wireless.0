Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:59718 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754057AbYJEPQp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 11:16:45 -0400
Date: Sun, 5 Oct 2008 08:14:52 -0700
From: Greg KH <greg@kroah.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: proski@gnu.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: at76_usb driver status
Message-ID: <20081005151452.GC20764@kroah.com> (sfid-20081005_171651_617328_73552EA9)
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com> <20081005061603.GB28533@kroah.com> <87d4ifsgg5.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87d4ifsgg5.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 05, 2008 at 09:29:14AM +0300, Kalle Valo wrote:
> Greg KH <greg@kroah.com> writes:
> 
> >> > So I was wondering what the status of this driver is, and if I
> >> > could/should add it to drivers/staging/?
> >> 
> >> The original at76_usb is working quite well, but it's unacceptable for
> >> the mainline because we cannot have two 802.11 stacks in kernel.
> >
> > I understand this, but for the issue of the drivers/staging/ tree, it's
> > ok for us to have as many 802.11 stacks in the kernel as we can cram in
> > there :)
> 
> That's good.
> 
> > See my previous posts on lkml for details on the staging tree if you
> > have questions about it.
> >
> > So for now, if no one really screams, I'll put Pavel's driver into the
> > drivers/staging/ tree so that users can use their devices.  When your
> > driver is merged, we can merely delete this driver instead.
> >
> > Sound good?
> 
> That sounds very good. User's benefit from this and that's what
> counts.
> 
> BTW, Pavel doesn't have time for at76 anymore. So if you have any
> problems with Pavel's driver in the stating tree, I can help you.

Thanks for the offer, hopefully I'll not have to take you up on it.

greg k-h
