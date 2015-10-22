Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54410 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964871AbbJVOMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 10:12:52 -0400
Date: Thu, 22 Oct 2015 07:29:19 -0700 (PDT)
Message-Id: <20151022.072919.1996665963889101709.davem@davemloft.net> (sfid-20151022_161259_773043_6DA056C9)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2015-10-21
From: David Miller <davem@davemloft.net>
In-Reply-To: <1445440026.4558.62.camel@sipsolutions.net>
References: <1445440026.4558.62.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 21 Oct 2015 17:07:06 +0200

> Here's another, likely final, pull request for -next. I finally caved
> in and cleaned up the regulatory code a bit, which is the bulk of the
> changes.
> 
> There's a new Kconfig which allows turning off CRDA, but it's hidden
> behind having the internal regdb enabled, which in turn is hidden
> behind EXPERT, so hopefully you won't even see that :) (although I am
> hoping to get rid of the internal regdb sooner rather than later)
> 
> Let me know if you see any problems.

Pulled, thanks a lot Johannes.
