Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43261
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966701AbXEGUgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2007 16:36:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Gary Zambrano" <zambrano@broadcom.com>
Subject: Re: Merging SSB upstream
Date: Mon, 7 May 2007 22:35:58 +0200
Cc: "Jeff Garzik" <jeff@garzik.org>,
	"John Linville" <linville@tuxdriver.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
References: <200705060303.17594.mb@bu3sch.de> <463D4770.9060903@garzik.org> <1178556198.8350.2.camel@dhcp-10-12-136-115.broadcom.com>
In-Reply-To: <1178556198.8350.2.camel@dhcp-10-12-136-115.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200705072235.58587.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 May 2007 18:43:18 Gary Zambrano wrote:
> On Sat, 2007-05-05 at 23:11 -0400, Jeff Garzik wrote:
> > Michael Buesch wrote:
> > > So, now that mac80211 is merged upstream, I think it's
> > > time to merge SSB and the b44-ssb port upstream.
> > > Note that bcm43xx-mac80211 is _not_ ready for upstream, yet.
> > > 
> > > What do you think? I'd like to merge ssb as-is, although
> > > the embedded-device parts are not quite finished, yet.
> > > But they don't interfere with the non-embedded parts used
> > > by b44 and the bcm43xx PCI cards.
> > > So we _could_ remove the ssb-mips code, but I don't like to
> > > do that for better maintainability. It doesn't hurt anyone IMO.
> > 
> > What does Ralf (MIPS maintainer) and Gary (Broadcom maintainer) think?
> > 
> > For my part, I'm not going to render even a tentative opinion without a 
> > link to actual code.
> > 
> > Last I saw of the code, and descriptions in IRC, it sounded sane.
> > 
> > 	Jeff
> > 
> 
> I would like to put some test mileage behind the ssb.
> We had a hard time testing it a while back, so we will try the latest.

Ok, nice to hear. :)
I stresstested latest ssb on my b44 card and it works fine here.
No TX timeouts or something.

-- 
Greetings Michael.
