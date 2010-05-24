Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:50823 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab0EXTOU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 15:14:20 -0400
Date: Mon, 24 May 2010 22:14:03 +0300
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Silence debug prints when using adhoc mode
Message-ID: <20100524191403.GE19669@nalle>
References: <20100523162240.GZ19669@nalle> <1274688345.3743.2.camel@jlt3.sipsolutions.net> <20100524081455.GB19669@nalle> <1274689457.3743.15.camel@jlt3.sipsolutions.net> <20100524135940.GD19669@nalle>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100524135940.GD19669@nalle>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 24, 2010 at 04:59:40PM +0300, Mikko Rapeli wrote:
> With debug logging the problem seems to go away, I will try the timer
> patch next:

For some reason I now can't repeat that logging storm with 2.6.32-trunk,
-5 or -3 from Debian, or vanilla 2.6.34. My syslogs are full of these, but
just can't repeat it now. I'm going to run 2.6.34 without MAC802 debug options
for now.

-Mikko
