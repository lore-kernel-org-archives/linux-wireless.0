Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([204.152.186.63]:32965 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbXCNWHj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2007 18:07:39 -0400
Date: Wed, 14 Mar 2007 22:05:38 +0000
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Kyle McMartin <kyle@canonical.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, hostap@shmoo.com, j@w1.fi
Subject: Re: [HOSTAP] Make debug a run-time option
Message-ID: <20070314220538.GA23642@hostap.isc.org>
References: <20070314160356.GA16337@athena.road.mcmartin.ca> <20070314171742.GA20779@hostap.isc.org> <20070314194800.GF3372@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070314194800.GF3372@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 14, 2007 at 03:48:00PM -0400, John W. Linville wrote:

> What about a combined approach?  The existing compile-time option
> could remain while runtime restrictions could be added for when the
> debug stuff is compiled into the driver?

I would be perfectly fine with doing that assuming the default behavior
is not changed with this patch (i.e., debugging would be enabled by
default). I would consider changing the default setting a separate issue
and for that, it might be more worthwhile approach to identify the debug
messages that are undesired by default than to disable everything.

-- 
Jouni Malinen                                            PGP id EFC895FA
