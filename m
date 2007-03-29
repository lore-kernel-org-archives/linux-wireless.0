Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-40.dex002.intermedia.net ([64.78.21.127]:54325 "EHLO
	dhost002-40.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030346AbXC2QKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 12:10:23 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Thu, 29 Mar 2007 08:44:31 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Subject: Re: WPA/RSN information in cfg80211?
Message-ID: <20070329154431.GA3906@devicescape.com>
References: <1175034846.5151.20.camel@johannes.berg> <20070328190017.GI6036@devicescape.com> <1175166739.8807.46.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1175166739.8807.46.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 29, 2007 at 01:12:19PM +0200, Johannes Berg wrote:
> On Wed, 2007-03-28 at 12:00 -0700, Jouni Malinen wrote:
> > As long as the information is available for the driver at the time of
> > association request, it does not really matter how that information got
> > there..
> 
> I'd have thought you would rather see the IE included to be able to
> experiment with new things easier ;)

Looks like there is some misunderstanding here.. What I meant with "the
information" was both the IE and the individual parameters. I do indeed
want to get both of these available to the drivers.

> I really can't decide which way to use. Piecing together the IE in the
> kernel and then just passing it doesn't seem like much overhead, but
> doing it in userspace gives us more freedom for experiments...

I believe both should be provided from user space and kernel has option
of using either one depending on needs.

-- 
Jouni Malinen                                            PGP id EFC895FA
