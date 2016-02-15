Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36594 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbcBOXqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 18:46:11 -0500
Received: by mail-io0-f195.google.com with SMTP id b188so13722906iof.3
        for <linux-wireless@vger.kernel.org>; Mon, 15 Feb 2016 15:46:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1455173229-6383-1-git-send-email-royujjal@gmail.com>
References: <1455173229-6383-1-git-send-email-royujjal@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 16 Feb 2016 10:45:51 +1100
Message-ID: <CAGRGNgU3WcrwBquYx-wVgq=c3fQ1CaPeapKbVt3ZnXOWfpQowA@mail.gmail.com> (sfid-20160216_004616_067683_C3282F60)
Subject: Re: [PATCH 1/3] mwifiex: Fixed incorrect indentation issue
To: Ujjal Roy <royujjal@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Thu, Feb 11, 2016 at 5:47 PM, Ujjal Roy <royujjal@gmail.com> wrote:
> This patch fixes the incorrect indentation of the case label.
>
> Signed-off-by: Ujjal Roy <royujjal@gmail.com>

Looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

> ---
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> index e7adef7..cb0cf03 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> @@ -676,7 +676,7 @@ mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
>                 }
>                 break;
>
> -               case MWIFIEX_BSS_ROLE_STA:
> +       case MWIFIEX_BSS_ROLE_STA:
>                 if (priv->media_connected) {
>                         mwifiex_dbg(adapter, ERROR,
>                                     "cannot change wiphy params when connected");
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
