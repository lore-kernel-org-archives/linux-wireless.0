Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46568 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab0CSUdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 16:33:16 -0400
Date: Fri, 19 Mar 2010 16:31:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>, stable@kernel.org
Subject: Re: [PATCH] ssb: do not read SPROM if it does not exist
Message-ID: <20100319203131.GE9552@tuxdriver.com>
References: <4BA266FB.1080507@lwfinger.net> <201003192041.47211.mb@bu3sch.de> <20100319202120.GD9552@tuxdriver.com> <201003192130.50798.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201003192130.50798.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 19, 2010 at 09:30:50PM +0100, Michael Buesch wrote:
> On Friday 19 March 2010 21:21:21 John W. Linville wrote:
> > -       if (bus->chip_rev >= 31)
> > +       if (bus->chipco.dev->id.revision >= 31)
> > 
> > Is that right?
> 
> Yeah, that's OK. Same goes for the other revision tests.

Cool, thanks!

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
