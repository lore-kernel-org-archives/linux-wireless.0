Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38009 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbaFEMjf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 08:39:35 -0400
Message-ID: <1401971964.4168.4.camel@jlt4.sipsolutions.net> (sfid-20140605_143939_080817_18E6812A)
Subject: Re: [PATCH v3 0/2] mac80211: fix csa counters
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 05 Jun 2014 14:39:24 +0200
In-Reply-To: <1401970897-21389-1-git-send-email-michal.kazior@tieto.com> (sfid-20140605_142925_177877_7C1D13CC)
References: <1401345535-22991-1-git-send-email-michal.kazior@tieto.com>
	 <1401970897-21389-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140605_142925_177877_7C1D13CC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-06-05 at 14:21 +0200, Michal Kazior wrote:
> Hi,
> 
> I was seeing strange WARN_ON splat loops and
> crashes while I was testing my multi-vif CSA.
> 
> CSA counters weren't properly reset and on some
> failpaths this caused a mess. There were also
> possible SMP inconsitencies/races.
> 
> 
> v2:
>  * dropped the atomic counter patch
>  * fix patch 1
> 
> v3:
>  * change sizeof(*x) -> sizeof(x[0]) [Johannes]
>  * rebase to 1238bbdc6c2cee366eea5ce5d56170b7fdd6ffd7

Applied, thanks!

johannes

