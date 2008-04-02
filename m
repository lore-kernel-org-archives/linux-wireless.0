Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from b.mail.sonic.net ([64.142.19.5]:47491 "EHLO b.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477AbYDBVWm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 17:22:42 -0400
From: Jason Riedy <jason@acm.org>
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Remove most references to iwl4965-only features from iwl3945.
References: <87bq4shix3.fsf@sparse.dyndns.org>
	<1ba2fa240804021250t4d0f3e12g201f1af253dea838@mail.gmail.com>
Date: Wed, 02 Apr 2008 14:22:29 -0700
In-Reply-To: <1ba2fa240804021250t4d0f3e12g201f1af253dea838@mail.gmail.com>
	(Tomas Winkler's message of "Wed, 2 Apr 2008 22:50:31 +0300")
Message-ID: <87prt86jfu.fsf@sparse.dyndns.org> (sfid-20080402_222248_325485_3A827D04)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And Tomas Winkler writes:
> This one is not supported in 3945 for real.

Someone with access to the documentation should rip the 4965-only
pieces out of the 3945-only driver...

Jason
