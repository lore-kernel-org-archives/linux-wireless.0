Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:58960 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753314AbZCTV00 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 17:26:26 -0400
Date: Fri, 20 Mar 2009 14:25:15 -0700
From: Greg KH <greg@kroah.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	otus-devel@lists.madwifi-project.org
Subject: Re: [RFC][RFT][PATCH 0/5 v5] ar9170: ar9170 driver (aka mac80211's
	otus)
Message-ID: <20090320212515.GA12078@kroah.com> (sfid-20090320_222630_263235_F6146559)
References: <200903170408.12626.chunkeey@web.de> <200903202036.09255.chunkeey@web.de> <20090320201326.GA30639@kroah.com> <200903202214.51394.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200903202214.51394.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 20, 2009 at 10:14:51PM +0100, Christian Lamparter wrote:
> On Friday 20 March 2009 21:13:26 Greg KH wrote:
> > On Fri, Mar 20, 2009 at 08:36:08PM +0100, Christian Lamparter wrote:
> > > Based on the number of mails I got, this driver should be ready for inclusion.
> > > So, this is probably the last RFC and the official patches will follow on
> > > sunday (only if no one finds a bug that needs to be fixed ASAP.)
> > 
> > Wonderful!
> :-)
> 
> > When the driver goes into the "real" portion of drivers/net please let
> > me know and I'll drop the otus driver from the drivers/staging/
> > location.
> Well, I doubt that we can replace Otus, ever...

Why, what is lacking in the version you have that is in the otus driver?

thanks,

greg k-h
