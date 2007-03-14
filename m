Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4599 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030871AbXCNUCZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2007 16:02:25 -0400
Date: Wed, 14 Mar 2007 15:48:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kyle McMartin <kyle@canonical.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, hostap@shmoo.com, j@w1.fi
Subject: Re: [HOSTAP] Make debug a run-time option
Message-ID: <20070314194800.GF3372@tuxdriver.com>
References: <20070314160356.GA16337@athena.road.mcmartin.ca> <20070314171742.GA20779@hostap.isc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070314171742.GA20779@hostap.isc.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 14, 2007 at 05:17:42PM +0000, Jouni Malinen wrote:
> On Wed, Mar 14, 2007 at 12:03:56PM -0400, Kyle McMartin wrote:
> > Build-time debugging isn't overly useful for distro kernel folks, nor is
> > enabling huge amounts of debug spew by default. Provide the option of
> > enabling debugging with module parameters.
> 
> While I understand that it would be difficult to change the debug level
> options with binary distributions, I'm not sure whether I would like to
> see these changes going in. PRISM2_NO_DEBUG was added to make it
> possible to reduce the driver size considerably. In addition, the change

What about a combined approach?  The existing compile-time option
could remain while runtime restrictions could be added for when the
debug stuff is compiled into the driver?

John
-- 
John W. Linville
linville@tuxdriver.com
