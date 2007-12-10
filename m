Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44086
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751182AbXLJGKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 01:10:50 -0500
Date: Sun, 09 Dec 2007 22:10:48 -0800 (PST)
Message-Id: <20071209.221048.187424680.davem@davemloft.net> (sfid-20071210_061054_746626_93F7E4E3)
To: dcbw@redhat.com
Cc: jt@hpl.hp.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
From: David Miller <davem@davemloft.net>
In-Reply-To: <1197223174.9149.60.camel@localhost.localdomain>
References: <20071207.180408.55119728.davem@davemloft.net>
	<1197221706.9149.36.camel@localhost.localdomain>
	<1197223174.9149.60.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>
Date: Sun, 09 Dec 2007 12:59:34 -0500

> Do either of those sound better to you than extending struct
> iw_range?

I find it interesting that we're willing to invest so much into
new WEXT hacks, but zero effort in converting the same applications
over the nl80211.

Even if you did it only for this new functionality, it would be
100 times better investment of your time than continuing this
WEXT nightmare.
