Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:56496 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbcBWKPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 05:15:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thierry Reding <thierry.reding@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	Alexandre Courbot <gnurou@gmail.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Marc Dietrich <marvin24@gmx.de>
Subject: Re: [PATCHv2 3/4] ARM: tegra: use build-in device properties with rfkill_gpio
Date: Tue, 23 Feb 2016 11:15:31 +0100
Message-ID: <5438459.Mb6Ga2Xhyq@wuerfel> (sfid-20160223_111610_131087_24A2182C)
In-Reply-To: <1455825889.2084.16.camel@sipsolutions.net>
References: <1453712629-143317-1-git-send-email-heikki.krogerus@linux.intel.com> <1453797724.2759.4.camel@sipsolutions.net> <1455825889.2084.16.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 February 2016 21:04:49 Johannes Berg wrote:
> On Tue, 2016-01-26 at 09:42 +0100, Johannes Berg wrote:
> > On Mon, 2016-01-25 at 13:18 +0100, Thierry Reding wrote:
> > >  
> > > Johannes, I assume that you'll want to take this through your tree
> > > because of the dependency? In that case:
> > > 
> > > Acked-by: Thierry Reding <treding@nvidia.com>
> > 
> > I can, but I don't really care - perhaps you'd rather take the entire
> > series through your tree to get it into one place for Marc?
> > 
> > In which case, you have my
> > 
> > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> > 
> > for the other 3 patches.
> > 
> > Let me know which you prefer.
> > 
> Did these patches get applied anywhere? Otherwise I'm willing to pick
> them up.
> 

Fine with me too:

Acked-by: Arnd Bergmann <arnd@arndb.de>

Just for my curiosity: what is the difference between a rfkill-gpio
device and a gpio-keys device with a KEY_RFKILL code?

arch/arm/boot/dts/bcm4708-netgear-r6250.dts and others seem to
do the second approach in DT so they don't need to create the
platform device.

	Arnd
