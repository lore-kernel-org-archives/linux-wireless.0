Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:53820 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbZDNM2d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 08:28:33 -0400
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Forest Bond <forest@alittletooquiet.net>, Greg KH <greg@kroah.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
In-Reply-To: <1239709727.4778.6.camel@johannes.local>
References: <20090414105200.GE25746@storm.local.network>
	 <1239707258.4778.3.camel@johannes.local>
	 <20090414113928.GA20470@storm.local.network>
	 <1239709727.4778.6.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 14:28:26 +0200
Message-Id: <1239712106.11795.21.camel@violet> (sfid-20090414_142839_139333_63E02AAA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > Can we also please add files here saying to not bother the
> > > linux-wireless list about this crap?
> > 
> > I would assume this is somewhat implied for any code in drivers/staging.  Is
> > that not the case?
> 
> It seems to be on a per case basis -- and there's one driver at least
> (agnx) that we actually do care about because it is there only because
> it's incomplete not because the code is in some way problematic (like
> using its own 802.11 stack)

just to document the irony here. Two or three years ago at OLS, Kyle and
Greg were making fun of Ubuntu merging its 5th wireless stack into their
kernel. Now the staging crap is doing exactly the same.

Not to mention the regulatory database I found in this specific driver.

At some point I like to see some proper future development/cleanup
planning for drivers in the staging area. Dumping stuff in there doesn't
help at all and personally I don't see anybody cleaning up this mess.

Do we have an option to taint the kernel when a staging driver is used.
Similar to what we do with binary drivers or ndiswrapper?

Regards

Marcel


