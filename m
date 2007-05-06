Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:35225 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbXEFDLy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 May 2007 23:11:54 -0400
Message-ID: <463D4770.9060903@garzik.org>
Date: Sat, 05 May 2007 23:11:44 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Gary Zambrano <zambrano@broadcom.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: Merging SSB upstream
References: <200705060303.17594.mb@bu3sch.de>
In-Reply-To: <200705060303.17594.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> So, now that mac80211 is merged upstream, I think it's
> time to merge SSB and the b44-ssb port upstream.
> Note that bcm43xx-mac80211 is _not_ ready for upstream, yet.
> 
> What do you think? I'd like to merge ssb as-is, although
> the embedded-device parts are not quite finished, yet.
> But they don't interfere with the non-embedded parts used
> by b44 and the bcm43xx PCI cards.
> So we _could_ remove the ssb-mips code, but I don't like to
> do that for better maintainability. It doesn't hurt anyone IMO.

What does Ralf (MIPS maintainer) and Gary (Broadcom maintainer) think?

For my part, I'm not going to render even a tentative opinion without a 
link to actual code.

Last I saw of the code, and descriptions in IRC, it sounded sane.

	Jeff



