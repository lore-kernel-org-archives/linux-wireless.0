Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41319 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbZAFUam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 15:30:42 -0500
Date: Tue, 6 Jan 2009 15:15:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Claudio <der.claudio@aon.at>, linux-wireless@vger.kernel.org,
	Greg KH <gregkh@suse.de>
Subject: Re: status of at76-usb driver
Message-ID: <20090106201517.GD3544@tuxdriver.com> (sfid-20090106_213051_251474_27EB9FD8)
References: <1230411118.4956956ecb911@webmail.aon.at> <87fxk8o2g0.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87fxk8o2g0.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 28, 2008 at 03:26:55PM +0200, Kalle Valo wrote:

> Fortunately Greg created staging tree some time ago and included the
> original at76_usb driver to the tree:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=tree;f=drivers/staging/at76_usb;hb=HEAD
> 
> So starting from 2.6.28 (please correct me if I'm wrong here) the
> original (and working!) at76_usb driver should be included already in
> the kernel, it's just up to the distributions to enable it.
> 
> Grep, I noticed that the TODO file in your tree doesn't mention
> anything about my mac80211 port. I'll send you a patch fixing that.
> 
> Also I'm going to rename the mac80211 port to something else for just
> to avoid the confusion with the original driver. Last thing I want to
> see is having two in-tree drivers with identical names.

OK, I still have patches to recreate the original port of at76_usb
to mac80211 and another to keep-up with a later mac80211 API change
on the at76 branch of wireless-testing.  I had intended to send them
to Greg now that the mac80211 API change has made it upstream.

Since you mentioned a) that you are working on the port again and b)
you are going to rename the driver for mac80211, should I just drop
my at76 branch of wireless testing for good?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
