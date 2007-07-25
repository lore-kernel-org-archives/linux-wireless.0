Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2509 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756808AbXGYPGG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 11:06:06 -0400
Date: Wed, 25 Jul 2007 10:46:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: James Ketrenos <jketreno@linux.intel.com>,
	Stephen Clark <Stephen.Clark@seclark.us>,
	ipw3945-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, Axj <axjslack@bluebottle.com>
Subject: Re: [ipw3945-devel] Request for help...
Message-ID: <20070725144651.GA7093@tuxdriver.com>
References: <1185289332.46a61474a444c@mail.bluebottle.com> <20070724161226.GA24344@tuxdriver.com> <46A64503.1080003@seclark.us> <20070724203035.GG24344@tuxdriver.com> <46A66B63.6030006@garzik.org> <46A6A447.2080903@linux.intel.com> <46A69359.4030201@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46A69359.4030201@garzik.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 24, 2007 at 08:03:37PM -0400, Jeff Garzik wrote:

> Though in fairness, I am a bit disappointed that wireless-dev seems to 
> occasionally become a resting place for drivers, rather than just a pit 
> stop on the way to upstream.  In particular, stuff still has not been 
> moved out of drivers/net/wireless/mac80211 and into 
> drivers/net/wireless, which is a basic and easy step to get all code 
> ready for upstream.

Point taken.  I'll apply a series of patches to eliminate the extra
directory.  I guess I'll rename the existing bcm43xx and zd1211rw
drivers in wireless-dev as a temporary measure until those ports are
done upstream.

I would definitely like to see more action from mac80211 driver
developers towards getting drivers upstream.  With mac80211 merged,
I know of no reason not to get the drivers ready for upstream now so
they can funnel through netdev-2.6 into -mm with plenty of time to
spare before the next merge window.

John
-- 
John W. Linville
linville@tuxdriver.com
