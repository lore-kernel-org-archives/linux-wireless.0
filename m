Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:51697 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759344AbZHRQqi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 12:46:38 -0400
Received: by yxe5 with SMTP id 5so4674294yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 09:46:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250607232-24870-1-git-send-email-linville@tuxdriver.com>
References: <1250607232-24870-1-git-send-email-linville@tuxdriver.com>
Date: Tue, 18 Aug 2009 09:46:38 -0700
Message-ID: <445f43ac0908180946u7415286ag519c9ca417f534ff@mail.gmail.com>
Subject: Re: [PATCH 1/2] rc80211_pid_algo.c: remove unused variable
	declaration
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks, John.

On Tue, Aug 18, 2009 at 7:53 AM, John W. Linville<linville@tuxdriver.com> wrote:
>  CC [M]  net/mac80211/rc80211_pid_algo.o
> net/mac80211/rc80211_pid_algo.c: In function ‘rate_control_pid_rate_init’:
> net/mac80211/rc80211_pid_algo.c:304: warning: unused variable ‘si’
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
Acked-by: Javier Cardona <javier@cozybit.com>


> ---
>  net/mac80211/rc80211_pid_algo.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
> index f6e25d7..699d3ed 100644
> --- a/net/mac80211/rc80211_pid_algo.c
> +++ b/net/mac80211/rc80211_pid_algo.c
> @@ -301,7 +301,6 @@ rate_control_pid_rate_init(void *priv, struct ieee80211_supported_band *sband,
>        struct rc_pid_sta_info *spinfo = priv_sta;
>        struct rc_pid_info *pinfo = priv;
>        struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
> -       struct sta_info *si;
>        int i, j, tmp;
>        bool s;
>
> --
> 1.6.2.5
>
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
