Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60224 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbZG0TCl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 15:02:41 -0400
Subject: Re: [PATCH 1/3] mac80211: cooperate more with network namespaces
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248718929.13118.3.camel@johannes.local>
References: <20090713223333.042733013@sipsolutions.net>
	 <20090713223413.255405284@sipsolutions.net>  <1248653082.3106.7.camel@mj>
	 <1248683249.19945.29.camel@johannes.local>  <1248708886.2688.4.camel@mj>
	 <1248710387.8500.5.camel@johannes.local>
	 <1248710568.8500.7.camel@johannes.local>  <1248711120.6965.6.camel@mj>
	 <1248712821.11808.6.camel@mj>  <1248718929.13118.3.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 15:02:39 -0400
Message-Id: <1248721359.7440.2.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-07-27 at 20:22 +0200, Johannes Berg wrote:

> Nah, the bug is far more far-reaching, please see and try the patch
> below.

Yes, it's working!  There are no crashes with correct and incorrect PSK.

I'm not very interested in making code look nicer if the real problem is
elsewhere.  I just assumed that the problem was where the panic
happened.

-- 
Regards,
Pavel Roskin
