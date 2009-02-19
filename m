Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48756
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbZBSBdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 20:33:50 -0500
Date: Wed, 18 Feb 2009 17:33:34 -0800 (PST)
Message-Id: <20090218.173334.110224475.davem@davemloft.net> (sfid-20090219_023355_765294_D3215971)
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, tgraf@redhat.com
Subject: Re: [PATCH] genetlink: introduce pre/post methods
From: David Miller <davem@davemloft.net>
In-Reply-To: <1234515865.4204.16.camel@johannes.local>
References: <1234515865.4204.16.camel@johannes.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 13 Feb 2009 10:04:25 +0100

> Sometimes doit/dumpit callbacks for a given family consist
> of quite a bit of boilerplate code, for example locking or
> generic sanity checks on messages.
> 
> These methods allow writing the boilerplate code just once
> instead of copying it into all handlers.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I'm fine with this:

Acked-by: David S. Miller <davem@davemloft.net>

Feel free to toss it into the wireless tree.
