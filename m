Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55051 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918AbbCCKel (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 05:34:41 -0500
Message-ID: <1425378875.2450.40.camel@sipsolutions.net> (sfid-20150303_113530_727100_182AC221)
Subject: Re: [PATCH net-next 13/14] wireless: Use eth_<foo>_addr instead of
 memset
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Mar 2015 11:34:35 +0100
In-Reply-To: <1425378573.17273.9.camel@perches.com>
References: <cover.1425354527.git.joe@perches.com>
	 <0c710456e4875ff00c1a9fcff9378ed15110dcd3.1425354528.git.joe@perches.com>
	 <1425370617.2450.3.camel@sipsolutions.net>
	 <1425371858.17273.3.camel@perches.com>
	 <1425372295.2450.9.camel@sipsolutions.net>
	 <1425372748.17273.6.camel@perches.com>
	 <1425373219.2450.13.camel@sipsolutions.net>
	 <1425378573.17273.9.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-03 at 02:29 -0800, Joe Perches wrote:

> Nope, you simply misunderstood what I did write.
> 
> What I said was that the arguments were likely
> already aligned(2), not that the alignment was
> a requirement.

Fair enough. That's not actually true/guaranteed though as far as this
patch is concerned.

johannes

