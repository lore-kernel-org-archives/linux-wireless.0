Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45178 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756209AbdJJNlK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 09:41:10 -0400
Date: Tue, 10 Oct 2017 15:41:08 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: toke@toke.dk
Subject: Re: [PATCH v2] mac80211: fix STA_SLOW_THRESHOLD htmldocs failure
Message-ID: <20171010134107.GA3328@redhat.com> (sfid-20171010_154200_489138_52F1C8CD)
References: <1506426485-7539-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506426485-7539-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 26, 2017 at 01:48:05PM +0200, Stanislaw Gruszka wrote:
> Patch fixes htmldocs build problem:
> 
> Error(.//net/mac80211/sta_info.h:416): cannot understand prototype: 'STA_SLOW_THRESHOLD 6000  '
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> v1 -> v2: just fix documentation build, do not move the code.

Johannes, would you apply this? I think patch is safe to apply :-)

>  net/mac80211/sta_info.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index 3acbdfa..a35c964 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -398,7 +398,7 @@ struct ieee80211_sta_rx_stats {
>  	u64 msdu[IEEE80211_NUM_TIDS + 1];
>  };
>  
> -/**
> +/*
>   * The bandwidth threshold below which the per-station CoDel parameters will be
>   * scaled to be more lenient (to prevent starvation of slow stations). This
>   * value will be scaled by the number of active stations when it is being
> -- 
> 1.7.1
> 
