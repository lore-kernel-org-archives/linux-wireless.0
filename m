Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab1KHNOP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 08:14:15 -0500
Subject: Re: [PATCH 2/3] mac80211: remove useless brackets in
 ieee80211_cfg_on_oper_channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320313247-23167-2-git-send-email-sgruszka@redhat.com>
References: <1320313247-23167-1-git-send-email-sgruszka@redhat.com>
	 <1320313247-23167-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 14:14:11 +0100
Message-ID: <1320758051.4304.31.camel@jlt3.sipsolutions.net> (sfid-20111108_141417_568342_3E5CBA16)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-03 at 10:40 +0100, Stanislaw Gruszka wrote:
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/main.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 7710b10..cd87fd9 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -126,8 +126,8 @@ bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local)
>  		return false;
>  
>  	/* Check current hardware-config against oper_channel. */
> -	if ((local->oper_channel != local->hw.conf.channel) ||
> -	    (local->_oper_channel_type != local->hw.conf.channel_type))
> +	if (local->oper_channel != local->hw.conf.channel ||
> +	    local->_oper_channel_type != local->hw.conf.channel_type)
>  		return false;
>  
>  	return true;


