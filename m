Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:59410 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790AbXLJSLa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 13:11:30 -0500
Date: Mon, 10 Dec 2007 10:09:21 -0800
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
Message-ID: <20071210180921.GB7168@bougret.hpl.hp.com> (sfid-20071210_181154_438592_AE9FE6CB)
Reply-To: jt@hpl.hp.com
References: <20071206191150.GC5237@bougret.hpl.hp.com> <1197022818.2603.20.camel@localhost.localdomain> <20071207192756.GA15864@bougret.hpl.hp.com> <20071207.180408.55119728.davem@davemloft.net> <1197221706.9149.36.camel@localhost.localdomain> <1197223174.9149.60.camel@localhost.localdomain> <1197288928.6035.59.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1197288928.6035.59.camel@johannes.berg>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 10, 2007 at 01:15:27PM +0100, Johannes Berg wrote:
> 
> > Do either of those sound better to you than extending struct iw_range?
> 
> Because wext is stupidly defined, you can never extend any structures it
> uses. Wext never passes in the length that userspace expects to passing
> in longer structures than the fixed one userspace expects will always
> overwrite something in userspace, possibly on the stack.
> 
> johannes

	Please check again...

	Jean
