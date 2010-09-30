Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:2588 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309Ab0I3Tg6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 15:36:58 -0400
Subject: Re: [PATCH] cfg80211: remove spurious __KERNEL__ ifdef
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285874485.5137.16.camel@jlt3.sipsolutions.net>
References: <1285874485.5137.16.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 12:36:57 -0700
Message-ID: <1285875417.9599.40.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-30 at 21:21 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The net/cfg80211.h header file isn't exported to
> userspace, so there's no need for any kind of
> __KERNEL__ protection in it. If it was exported,
> everything else in it would need protection as
> well, not just the logging stuff ...
> 
> Cc:Joe Perches <joe@perches.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> Might be something that slipped in elsewhere too?

I thought John was going to remove that guard.

http://lkml.org/lkml/2010/7/27/294

I believe John removed the other one.


