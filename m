Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38487 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112AbXGYPTt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 11:19:49 -0400
Message-ID: <46A76A0E.805@garzik.org>
Date: Wed, 25 Jul 2007 11:19:42 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: James Ketrenos <jketreno@linux.intel.com>,
	Stephen Clark <Stephen.Clark@seclark.us>,
	ipw3945-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, Axj <axjslack@bluebottle.com>
Subject: Re: [ipw3945-devel] Request for help...
References: <1185289332.46a61474a444c@mail.bluebottle.com> <20070724161226.GA24344@tuxdriver.com> <46A64503.1080003@seclark.us> <20070724203035.GG24344@tuxdriver.com> <46A66B63.6030006@garzik.org> <46A6A447.2080903@linux.intel.com> <46A69359.4030201@garzik.org> <20070725144651.GA7093@tuxdriver.com>
In-Reply-To: <20070725144651.GA7093@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> I would definitely like to see more action from mac80211 driver
> developers towards getting drivers upstream.  With mac80211 merged,
> I know of no reason not to get the drivers ready for upstream now so
> they can funnel through netdev-2.6 into -mm with plenty of time to
> spare before the next merge window.

Agreed.  Getting something upstream is the fastest way to mature a 
driver...  It gets far less testing and review hiding out in 
netdev-2.6.git or wireless-dev.git.

If it works, is relatively clean, and doesn't corrupt data or have 
races, push it upstream :)

	Jeff


