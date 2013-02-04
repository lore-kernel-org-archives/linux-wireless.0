Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:36737 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3BDRmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 12:42:38 -0500
Date: Mon, 4 Feb 2013 09:42:32 -0800
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	rusty@rustcorp.com.au, bfields@fieldses.org,
	skinsbursky@parallels.com, ebiederm@xmission.com,
	jmorris@namei.org, axboe@kernel.dk, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 59/62] mac80211: convert to idr_alloc()
Message-ID: <20130204174232.GO27963@mtj.dyndns.org> (sfid-20130204_184310_681596_B7FEB7A4)
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-60-git-send-email-tj@kernel.org>
 <1359999624.17993.21.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359999624.17993.21.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 04, 2013 at 06:40:24PM +0100, Johannes Berg wrote:
> On Sat, 2013-02-02 at 17:21 -0800, Tejun Heo wrote:
> > Convert to the much saner new idr interface.
> > 
> > Only compile tested.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > Cc: linux-wireless@vger.kernel.org
> > ---
> > This patch depends on an earlier idr changes and I think it would be
> > best to route these together through -mm.  Please holler if there's
> > any objection.  Thanks.
> 
> Looks fine to me, thanks.

Will add Acked-by.  Thanks a lot!

-- 
tejun
