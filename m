Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f195.google.com ([209.85.213.195]:34461 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbcBHWi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 17:38:26 -0500
MIME-Version: 1.0
In-Reply-To: <1454946096-9752-3-git-send-email-jprvita@endlessm.com>
References: <1454946096-9752-1-git-send-email-jprvita@endlessm.com> <1454946096-9752-3-git-send-email-jprvita@endlessm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 9 Feb 2016 09:38:06 +1100
Message-ID: <CAGRGNgXd-sPP-omQ-Vnkfgw7AGWa=8EaRQwL_jkTPnxKfdTSDQ@mail.gmail.com> (sfid-20160208_233847_005000_CC062B1F)
Subject: Re: [PATCH 2/9] rfkill: Remove extra blank line
To: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux@endlessm.com,
	=?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi João,

On Tue, Feb 9, 2016 at 2:41 AM, João Paulo Rechi Vita <jprvita@gmail.com> wrote:
> Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>

Looks sane to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  net/rfkill/core.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index ffbc375..56d79cb 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -455,7 +455,6 @@ bool rfkill_get_global_sw_state(const enum rfkill_type type)
>  }
>  #endif
>
> -
>  bool rfkill_set_hw_state(struct rfkill *rfkill, bool blocked)
>  {
>         unsigned long flags;
> --
> 2.5.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
