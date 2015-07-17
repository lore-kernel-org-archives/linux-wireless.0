Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52858 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180AbbGQNQh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 09:16:37 -0400
Message-ID: <1437138995.1933.13.camel@sipsolutions.net> (sfid-20150717_151640_511026_7E7DD6B1)
Subject: Re: [PATCH v3] cfg80211: Handle minimum bandwidth for quarter and
 half rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias May <matthias.may@neratec.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 17 Jul 2015 15:16:35 +0200
In-Reply-To: <55A8FF32.5070308@neratec.com>
References: <1434035553-6621-1-git-send-email-matthias.may@neratec.com>
		 (sfid-20150611_171301_187773_8C09D939) <1437136527.1933.9.camel@sipsolutions.net>
	 <55A8FF32.5070308@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-07-17 at 15:12 +0200, Matthias May wrote:
> 
> I've improved this patch a bit since i posted v3.
> Mainly setting more disabled flags when using a country code which 
> only 
> allows only narrow channels.
> In certain circumstance it was possible to start operation on a 20/10 
> 
> channel on a channel which only allowed 5/10.
> 
> I didn't post it yet because i was running some more tests with it 
> and 
> used it "productively" to see if something else breaks.
> Will post it now.
> 

Are you saying I should drop this version before I push it out?

johannes
