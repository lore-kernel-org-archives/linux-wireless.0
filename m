Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2217 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbYFIQII (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 12:08:08 -0400
Date: Mon, 9 Jun 2008 11:23:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Chris Wright <chrisw@sous-sol.org>, stable@kernel.org,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [stable] [PATCH stable] b43: Fix controller restart crash
Message-ID: <20080609152323.GA12654@tuxdriver.com> (sfid-20080609_180814_716659_9AAFB310)
References: <200806061558.42998.mb@bu3sch.de> <20080606173223.GR30402@sequoia.sous-sol.org> <200806061955.27951.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200806061955.27951.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 06, 2008 at 07:55:27PM +0200, Michael Buesch wrote:
> On Friday 06 June 2008 19:32:23 Chris Wright wrote:
> > * Michael Buesch (mb@bu3sch.de) wrote:
> > > This fixes a kernel crash on rmmod, in the case where the controller
> > > was restarted before doing the rmmod.
> > > 
> > > Upstream commit is 4735f5022c97f6624ced2ec5056c61c4b437d53b
> > 
> > This is not in Linus' tree.  Where is this upstream commit?
> 
> John Linville's wireless tree. That's upstream from my point of view. :P

:-)

The commit ID may have gotten shuffled when Dave M. rebased net-2.6.
It is in 2.6.26-rc5 as commit 3bf0a32e22fedc0b46443699db2d61ac2a883ac4.

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
