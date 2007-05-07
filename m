Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3646 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934438AbXEGSEN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2007 14:04:13 -0400
Subject: Re: Merging SSB upstream
From: "Gary Zambrano" <zambrano@broadcom.com>
To: "Jeff Garzik" <jeff@garzik.org>
cc: "Michael Buesch" <mb@bu3sch.de>,
	"John Linville" <linville@tuxdriver.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
In-Reply-To: <463D4770.9060903@garzik.org>
References: <200705060303.17594.mb@bu3sch.de>
 <463D4770.9060903@garzik.org>
Date: Mon, 07 May 2007 09:43:18 -0700
Message-ID: <1178556198.8350.2.camel@dhcp-10-12-136-115.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-05-05 at 23:11 -0400, Jeff Garzik wrote:
> Michael Buesch wrote:
> > So, now that mac80211 is merged upstream, I think it's
> > time to merge SSB and the b44-ssb port upstream.
> > Note that bcm43xx-mac80211 is _not_ ready for upstream, yet.
> > 
> > What do you think? I'd like to merge ssb as-is, although
> > the embedded-device parts are not quite finished, yet.
> > But they don't interfere with the non-embedded parts used
> > by b44 and the bcm43xx PCI cards.
> > So we _could_ remove the ssb-mips code, but I don't like to
> > do that for better maintainability. It doesn't hurt anyone IMO.
> 
> What does Ralf (MIPS maintainer) and Gary (Broadcom maintainer) think?
> 
> For my part, I'm not going to render even a tentative opinion without a 
> link to actual code.
> 
> Last I saw of the code, and descriptions in IRC, it sounded sane.
> 
> 	Jeff
> 

I would like to put some test mileage behind the ssb.
We had a hard time testing it a while back, so we will try the latest.
Thanks,
Gary

