Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54105 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829AbZCYPdf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 11:33:35 -0400
Subject: Re: wireless powersaving (in NM?)
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1237979070.4320.156.camel@johannes.local>
References: <1237891149.4320.73.camel@johannes.local>
	 <1237910398.9082.7.camel@localhost.localdomain>
	 <1237979070.4320.156.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 11:31:12 -0400
Message-Id: <1237995072.18896.9.camel@localhost.localdomain> (sfid-20090325_163339_636450_82DC6ABE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-03-25 at 12:04 +0100, Johannes Berg wrote:
> On Tue, 2009-03-24 at 11:59 -0400, Dan Williams wrote:
> 
> > or maybe gnome-power-manager (and whatever the kde equivalent is) should
> > be driving this based on all the other policy decisions it makes?  it's
> > the thing that handles whether you're on battery or on AC, what your
> > drive spin-down time is, it knows when your laptop lid is closed, what
> > your display brightness is at, etc.
> > 
> > it might use some information from NM as input, but the overall power
> > manager is probably where the actual policy decisions should be made.
> 
> Makes sense too. I guess that Marcel makes a compelling case for it
> always being enabled, and Kalle says we need to have an override --
> which semantically needs to be in NM/connman since that's where the user
> will look if the connection is flaky (because the AP is broken)

Yeah, sounds OK.  Just to be clear, problems with this code will appear
on a *per-AP* basis, not a per-card basis, right?  ie there are some
stupid APs that won't work with it, but it won't be the case that a
chipset will be broken for all APs, right?

Dan


