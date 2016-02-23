Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59254 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbcBWKbe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 05:31:34 -0500
Message-ID: <1456223487.2041.14.camel@sipsolutions.net> (sfid-20160223_113139_319658_D0118C98)
Subject: Re: [PATCHv2 3/4] ARM: tegra: use build-in device properties with
 rfkill_gpio
From: Johannes Berg <johannes@sipsolutions.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	Alexandre Courbot <gnurou@gmail.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Marc Dietrich <marvin24@gmx.de>
Date: Tue, 23 Feb 2016 11:31:27 +0100
In-Reply-To: <20160219180354.GA9911@ulmo> (sfid-20160219_190356_007406_5ADCBA2F)
References: <1453712629-143317-1-git-send-email-heikki.krogerus@linux.intel.com>
	 <1453712629-143317-4-git-send-email-heikki.krogerus@linux.intel.com>
	 <20160125121840.GA20452@ulmo.nvidia.com>
	 <1453797724.2759.4.camel@sipsolutions.net>
	 <1455825889.2084.16.camel@sipsolutions.net> <20160219180354.GA9911@ulmo>
	 (sfid-20160219_190356_007406_5ADCBA2F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-02-19 at 19:03 +0100, Thierry Reding wrote:
> On Thu, Feb 18, 2016 at 09:04:49PM +0100, Johannes Berg wrote:
> > On Tue, 2016-01-26 at 09:42 +0100, Johannes Berg wrote:
> > > On Mon, 2016-01-25 at 13:18 +0100, Thierry Reding wrote:
> > > >  
> > > > Johannes, I assume that you'll want to take this through your
> > > > tree
> > > > because of the dependency? In that case:
> > > > 
> > > > Acked-by: Thierry Reding <treding@nvidia.com>
> > > 
> > > I can, but I don't really care - perhaps you'd rather take the
> > > entire
> > > series through your tree to get it into one place for Marc?
> > > 
> > > In which case, you have my
> > > 
> > > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> > > 
> > > for the other 3 patches.
> > > 
> > > Let me know which you prefer.
> > > 
> > Did these patches get applied anywhere? Otherwise I'm willing to
> > pick
> > them up.
> 
> Might be easier for everyone if you took this one patch. My earlier
> Acked-by still stands:
> 
Yep, done. I've applied all 4 patches now.

johannes
