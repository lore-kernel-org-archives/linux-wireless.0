Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52388 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab0CRUbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 16:31:47 -0400
Subject: Re: RFC: A workaround for BCM43XX devices with no on-board SPROM
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx devel <Bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20100318202052.GD17357@tuxdriver.com>
References: <4BA266FB.1080507@lwfinger.net>
	 <201003182031.25013.mb@bu3sch.de>  <20100318202052.GD17357@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 13:31:45 -0700
Message-ID: <1268944305.4005.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-18 at 16:20 -0400, John W. Linville wrote:
> On Thu, Mar 18, 2010 at 08:31:24PM +0100, Michael Buesch wrote:
> > On Thursday 18 March 2010 18:46:35 Larry Finger wrote:
> 
> > > It it reasonable to keep the vendor portion of the MAC and only replace the
> > > "serial number", or would it be better to randomize all 6 octants?
> > 
> > I think it doesn't really matter.
> 
> It might be a good idea to set the LAA bit...?

And clear the mcast bit :)

johannes

