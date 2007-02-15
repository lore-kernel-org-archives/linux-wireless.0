Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58976 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S966123AbXBOQvc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 11:51:32 -0500
Date: Thu, 15 Feb 2007 17:51:25 +0100
From: Martin Langer <martin-langer@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>, Joseph Jezak <josejx@gentoo.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
Message-ID: <20070215165125.GA3328@tuba>
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net> <200702142240.01494.mb@bu3sch.de> <1171552024.5220.4.camel@johannes.berg> <200702151613.20746.mb@bu3sch.de> <1171552753.5220.10.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1171552753.5220.10.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 15, 2007 at 04:19:13PM +0100, Johannes Berg wrote:
> On Thu, 2007-02-15 at 16:13 +0100, Michael Buesch wrote:
> > On Thursday 15 February 2007 16:07, Johannes Berg wrote:
> > > On Wed, 2007-02-14 at 22:40 +0100, Michael Buesch wrote:
> > > > On Wednesday 14 February 2007 14:18, Johannes Berg wrote:
> > > > > On Sat, 2007-02-10 at 06:55 +0100, Michael Buesch wrote:
> > > > > 
> > > > > > It's likely that old cards still work with v4 firmware,
> > > > > 
> > > > > No, it's absolutely impossible. Rev 2/4 cores have a totally different
> > > > > instruction set in the microcode.
> > > > 
> > > > Ok, I was not talking about _that_ old cards. ;)
> > > 
> > > Are there cards where they have new microcode instruction set but no v4
> > > firmware?
> > 
> > I don't know. I guessed so. Am I wrong? That would be good :)
> 
> I wouldn't think so since we have rev5 v4 firmware and that should be
> the oldest post-rev4 right?

Yep. We have all kinds of firmware with the new instruction set. It's 
only ucode2 (old instruction set) that's missing. But the later ucode4 
which also uses the old instruction set is available in v4.
OTOH, ucode13 isn't available in v3. We can't offer one firmware version 
for all card revisions. Both are limited to a specific range of 
revisions.

v3	rev2...rev12
v4	rev4...<=rev13


Martin
