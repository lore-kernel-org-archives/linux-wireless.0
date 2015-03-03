Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:36239 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422AbbCCS5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 13:57:42 -0500
Date: Tue, 03 Mar 2015 13:57:37 -0500 (EST)
Message-Id: <20150303.135737.630359651880852880.davem@davemloft.net> (sfid-20150303_195759_315716_D957E126)
To: johannes@sipsolutions.net
Cc: joe@perches.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 13/14] wireless: Use eth_<foo>_addr instead of
 memset
From: David Miller <davem@davemloft.net>
In-Reply-To: <1425370617.2450.3.camel@sipsolutions.net>
References: <cover.1425354527.git.joe@perches.com>
	<0c710456e4875ff00c1a9fcff9378ed15110dcd3.1425354528.git.joe@perches.com>
	<1425370617.2450.3.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 03 Mar 2015 09:16:57 +0100

> Other than that, I guess I'll apply this, but I really wish there was a
> way to distinguish more easily which of these require alignment and
> which don't.

You can't apply "this" without the dependency patch #1.

Therefore this should probably all go through my tree.
