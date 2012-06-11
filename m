Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:38396 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750738Ab2FKRdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 13:33:31 -0400
Message-ID: <4FD62BDB.7000504@xenotime.net> (sfid-20120611_193335_117713_CEB49E34)
Date: Mon, 11 Jun 2012 10:33:15 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Ashok Nagarajan <ashok@cozybit.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	javier@cozybit.com, devel@lists.open80211s.org
Subject: Re: [PATCH] mac80211: add missing kernel-doc
References: <1339435415-9417-1-git-send-email-ashok@cozybit.com>
In-Reply-To: <1339435415-9417-1-git-send-email-ashok@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/2012 10:23 AM, Ashok Nagarajan wrote:

> Add a few kernel-doc descriptions that were missed
> during mesh development.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  net/mac80211/sta_info.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index 3bb24a1..672d9c6 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -271,6 +271,9 @@ struct sta_ampdu_mlme {
>   * @plink_timer: peer link watch timer
>   * @plink_timer_was_running: used by suspend/resume to restore timers
>   * @t_offset: timing offset relative to this host
> + * @t_offset_setpoint: reference timing offset of this sta to be used when
> + * 	calculating clockdrift
> + * @ch_type: peer's channel type
>   * @debugfs: debug filesystem info
>   * @dead: set to true when sta is unlinked
>   * @uploaded: set to true when sta is uploaded to the driver



-- 
~Randy
