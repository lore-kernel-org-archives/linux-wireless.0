Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:60446 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbYL2AgS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 19:36:18 -0500
Date: Sun, 28 Dec 2008 16:33:21 -0800
From: Greg KH <gregkh@suse.de>
To: Pavel Roskin <proski@gnu.org>
Cc: Kalle Valo <kalle.valo@iki.fi>, Claudio <der.claudio@aon.at>,
	linux-wireless@vger.kernel.org
Subject: Re: status of at76-usb driver
Message-ID: <20081229003321.GA7426@suse.de> (sfid-20081229_013622_273821_823BC0AD)
References: <1230411118.4956956ecb911@webmail.aon.at> <87fxk8o2g0.fsf@litku.valot.fi> <1230499683.25726.4.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1230499683.25726.4.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 28, 2008 at 04:28:03PM -0500, Pavel Roskin wrote:
> On Sun, 2008-12-28 at 15:26 +0200, Kalle Valo wrote:
> 
> > Also I'm going to rename the mac80211 port to something else for just
> > to avoid the confusion with the original driver. Last thing I want to
> > see is having two in-tree drivers with identical names.
> 
> I asked to rename the driver that was imported into the staging tree,
> but my request was ignored.

You did?  I don't see that in my email archives, sorry, did you cc: me?

> I guess nobody really cares about the name conflict.

What name conflict?  Is there in in-kernel with this same name for a
module?  If so, let me know and I'll be glad to rename the staging one.

> I'll appreciate if we avoid further renames.

renames are trivial :)

> Once the mac80211 port is working properly, it should be included in
> to the next kernel release, and the driver from the staging tree
> should be removed in the same kernel release.

When a "real" driver is included, I will be glad to delete the staging
driver.  Just let me know.

thanks,

greg k-h
