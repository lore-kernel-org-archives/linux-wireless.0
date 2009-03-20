Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:44159 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZCTVOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 17:14:54 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC][RFT][PATCH 0/5 v5] ar9170: ar9170 driver (aka mac80211's otus)
Date: Fri, 20 Mar 2009 22:14:51 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	otus-devel@lists.madwifi-project.org
References: <200903170408.12626.chunkeey@web.de> <200903202036.09255.chunkeey@web.de> <20090320201326.GA30639@kroah.com>
In-Reply-To: <20090320201326.GA30639@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903202214.51394.chunkeey@web.de> (sfid-20090320_221457_326493_8794DFB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 March 2009 21:13:26 Greg KH wrote:
> On Fri, Mar 20, 2009 at 08:36:08PM +0100, Christian Lamparter wrote:
> > Based on the number of mails I got, this driver should be ready for inclusion.
> > So, this is probably the last RFC and the official patches will follow on
> > sunday (only if no one finds a bug that needs to be fixed ASAP.)
> 
> Wonderful!
:-)

> When the driver goes into the "real" portion of drivers/net please let
> me know and I'll drop the otus driver from the drivers/staging/
> location.
Well, I doubt that we can replace Otus, ever...

But it would be nice to tell/warn the otus user (and possible devs)
about the existence of an alternative driver, that does not
TAINT the kernel.

> thanks,
> 
> greg k-h

Regards,
	Chr
