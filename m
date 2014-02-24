Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11826 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaBXIif (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 03:38:35 -0500
Date: Mon, 24 Feb 2014 10:38:20 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Marc Dietrich <marvin24@gmx.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@csie.org>,
	Rhyland Klein <rklein@nvidia.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: rfkill: gpio: remove unused and
 obsoleteplatform parameters
Message-ID: <20140224083820.GA15512@xps8300> (sfid-20140224_093857_861008_2620AFE2)
References: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1723302.jKkc8NDNRI@fb07-iapwap2>
 <20140221142349.GB10489@xps8300>
 <2556368.zbgmUK7WzX@ax5200p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2556368.zbgmUK7WzX@ax5200p>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 22, 2014 at 11:32:04PM +0100, Marc Dietrich wrote:
> On Friday 21 February 2014 16:23:49 Heikki Krogerus wrote:
> > On Fri, Feb 21, 2014 at 02:55:14PM +0100, Marc Dietrich wrote:
> > > arch/arm/mach-tegra/board-paz00.c is still using platform data. Is there
> > > some prerequisite patch I'm missing (3.14-rc3) or how can this file be
> > > converted? We are waiting for DT support to arrive so we can finally
> > > remove this file.
> > True! It still set's the shutdown_gpio and reset_gpio members. I think
> > I'll leave the header untouched and just clean net/rfkill/rfkill-gpio.c
> > in this patch. We can remove the whole header after you guys have moved
> > to DT.
> 
> Why? Just update the board file to remove those entries. I just checked that 
> it's working fine without. So if you don't mind, add a patch to remove the 
> entries as the first patch in your series.

I was hoping I wouldn't have to touch arch/arm/mach-tegra/board-paz00.c
any more. But OK, I'll add a patch and remove the entries.

Thanks,

-- 
heikki
