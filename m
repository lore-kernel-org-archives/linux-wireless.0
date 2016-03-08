Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:34175 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbcCHWbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 17:31:50 -0500
Received: by mail-ob0-f181.google.com with SMTP id ts10so28959787obc.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2016 14:31:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457446662-27437-1-git-send-email-retrage01@gmail.com>
References: <1457446662-27437-1-git-send-email-retrage01@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 9 Mar 2016 09:31:29 +1100
Message-ID: <CAGRGNgUDx=KW-1zpen7oCEAL9OvkZL4_nsh3wK58U3MF=wm=hw@mail.gmail.com> (sfid-20160308_233153_565038_3A8F69A8)
Subject: Re: [PATCH] Fix typo in cfg80211.h
To: Moroo Akira <retrage01@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Wed, Mar 9, 2016 at 1:17 AM, Moroo Akira <retrage01@gmail.com> wrote:
> From: Akira Moroo <retrage01@gmail.com>
>
> This patch fix a structure name typo in cfg80211.h.
>
> Signed-off-by: Moroo Akira <retrage01@gmail.com>

Looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  include/net/cfg80211.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 9bcaaf7..9570ade 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1609,17 +1609,17 @@ enum cfg80211_signal_type {
>  struct cfg80211_inform_bss {
>         struct ieee80211_channel *chan;
>         enum nl80211_bss_scan_width scan_width;
>         s32 signal;
>         u64 boottime_ns;
>  };
>
>  /**
> - * struct cfg80211_bss_ie_data - BSS entry IE data
> + * struct cfg80211_bss_ies - BSS entry IE data
>   * @tsf: TSF contained in the frame that carried these IEs
>   * @rcu_head: internal use, for freeing
>   * @len: length of the IEs
>   * @from_beacon: these IEs are known to come from a beacon
>   * @data: IE data
>   */
>  struct cfg80211_bss_ies {
>         u64 tsf;
> --
> 2.4.10
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
