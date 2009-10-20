Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:35699 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751072AbZJTSHf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 14:07:35 -0400
Received: from chimera.site ([96.253.169.185]) by xenotime.net for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 11:07:35 -0700
Date: Tue, 20 Oct 2009 11:07:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: trivial: fix spelling in mesh_hwmp
Message-Id: <20091020110735.445205d1.rdunlap@xenotime.net>
In-Reply-To: <1256061862-23368-1-git-send-email-andrey@cozybit.com>
References: <1256061862-23368-1-git-send-email-andrey@cozybit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 20 Oct 2009 11:04:22 -0700 Andrey Yurovsky wrote:

> Fix a couple of typos in the description of hwmp_route_info_get(), no
> functional changes.
> 
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
> ---
>  net/mac80211/mesh_hwmp.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index e12a786..c300911 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -259,12 +259,12 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
>   * @hwmp_ie: hwmp information element (PREP or PREQ)
>   *
>   * This function updates the path routing information to the originator and the
> - * transmitter of a HWMP PREQ or PREP fram.
> + * transmitter of a HWMP PREQ or PREP frame.
>   *
>   * Returns: metric to frame originator or 0 if the frame should not be further
>   * processed
>   *
> - * Notes: this function is the only place (besides user-provided info) where
> + * Notes: this function is the only place (beside user-provided info) where

This one was OK as is.  "besides" means "other than" or "except".

>   * path routing information is updated.
>   */
>  static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
> -- 


---
~Randy
