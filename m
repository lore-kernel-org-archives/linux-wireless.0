Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35695 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab0CTKJt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Mar 2010 06:09:49 -0400
Received: by wwe15 with SMTP id 15so2298871wwe.19
        for <linux-wireless@vger.kernel.org>; Sat, 20 Mar 2010 03:09:47 -0700 (PDT)
Message-ID: <4BA49EE2.8000902@gmail.com>
Date: Sat, 20 Mar 2010 10:09:38 +0000
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: correct typos in "unavailable upon resume"
 warning
References: <1268854418-6662-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1268854418-6662-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  net/mac80211/util.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index c453226..a9d9098 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1097,8 +1097,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>  		 */
>  		res = drv_start(local);
>  		if (res) {
> -			WARN(local->suspended, "Harware became unavailable "
> -			     "upon resume. This is could be a software issue"
> +			WARN(local->suspended, "Hardware became unavailable "
> +			     "upon resume. This is could be a software issue "

                                                ^^

As long as you're addressing that line, you probably want to lose the
'is'. Or the 'could be'.

>  			     "prior to suspend or a hardware issue\n");
>  			return res;
>  		}
