Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:46569 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZADQOm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 11:14:42 -0500
Date: Sun, 4 Jan 2009 17:28:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] Fix up truesize after pskb_expand_head() in wireless stack
Message-ID: <20090104162826.GT496@one.firstfloor.org> (sfid-20090104_171446_465292_AD4657C2)
References: <20090104151819.GA6590@basil.nowhere.org> <1231085150.3296.3.camel@johannes>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1231085150.3296.3.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Thanks, but I'll need to look at this in more detail, we need to make
> sure that we orphan the skb before 

What do you mean with orphaning the skb? 

etc. And then, we need to check
> whether it makes sense to do this in pskb_expand_head().

Well whatever you do this short term patch is needed, there's no 
reason to delay it.

-Andi
