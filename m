Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab1H0OuN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 10:50:13 -0400
Date: Sat, 27 Aug 2011 07:50:03 -0700
From: Greg KH <gregkh@suse.de>
To: Dan Carpenter <error27@gmail.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110827145003.GA9405@suse.de> (sfid-20110827_165017_486960_CE84D36A)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com>
 <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
 <20110827143513.GN3775@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20110827143513.GN3775@shale.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 27, 2011 at 05:35:13PM +0300, Dan Carpenter wrote:
> On Thu, Aug 25, 2011 at 10:55:26PM +0200, Rafał Miłecki wrote:
> > 2011/8/25 Henry Ptasinski <henryp@broadcom.com>:
> > > With the latest series of cleanup patches merged in by Greg KH, I'd like to
> > > once again propose moving brcm80211 out of staging and into mainline.
> > 
> > Henry: a simple question, please explain it to me, what brcmsmac does
> > provide that b43 doesn't?
> >
> 
> Wow.  Why are we only having this discussion now?  Somewhere along
> the line, there has been a massive communications failure.  What
> happened here?  Henry, did you know about the b43 driver?  Can
> someone explain what's going on?

I always thought that b43 and the staging driver supported different
devices and had no overlap, which is why I had no problem with it.

Was I totally mistaken and got this wrong?

greg k-h
