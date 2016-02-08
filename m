Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34194 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbcBHWhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 17:37:53 -0500
MIME-Version: 1.0
In-Reply-To: <1454946096-9752-2-git-send-email-jprvita@endlessm.com>
References: <1454946096-9752-1-git-send-email-jprvita@endlessm.com> <1454946096-9752-2-git-send-email-jprvita@endlessm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 9 Feb 2016 09:37:32 +1100
Message-ID: <CAGRGNgX7ANq_dTSkRCqnU2H5DQsLCf5Ni7M-n7Z_RSieOf=mOw@mail.gmail.com> (sfid-20160208_233813_006851_2B7F0CFF)
Subject: Re: [PATCH 1/9] rfkill: Improve documentation language
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

Looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  net/rfkill/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index a805831..ffbc375 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -282,8 +282,8 @@ static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
>         spin_lock_irqsave(&rfkill->lock, flags);
>         if (err) {
>                 /*
> -                * Failed -- reset status to _prev, this may be different
> -                * from what set set _PREV to earlier in this function
> +                * Failed -- reset status to _PREV, which may be different
> +                * from what we have set _PREV to earlier in this function
>                  * if rfkill_set_sw_state was invoked.
>                  */
>                 if (rfkill->state & RFKILL_BLOCK_SW_PREV)
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
