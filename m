Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33909 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbcBOXq4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2016 18:46:56 -0500
Received: by mail-io0-f194.google.com with SMTP id l127so13685618iof.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Feb 2016 15:46:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1455173229-6383-3-git-send-email-royujjal@gmail.com>
References: <1455173229-6383-1-git-send-email-royujjal@gmail.com> <1455173229-6383-3-git-send-email-royujjal@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 16 Feb 2016 10:46:36 +1100
Message-ID: <CAGRGNgUZ_HrBv3XBsZAHS6AZb5bWp7Sjt-xmSdyJ4_MesH2w3g@mail.gmail.com> (sfid-20160216_004659_600836_E0ED658B)
Subject: Re: [PATCH 3/3] mwifiex: Added missing spaces around brackets
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
> This patch fixes the missing spaces issue in coding style.
>
> Signed-off-by: Ujjal Roy <royujjal@gmail.com>

Looks right to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

> ---
>  drivers/net/wireless/marvell/mwifiex/usb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
> index e43aff9..0510861 100644
> --- a/drivers/net/wireless/marvell/mwifiex/usb.c
> +++ b/drivers/net/wireless/marvell/mwifiex/usb.c
> @@ -244,9 +244,9 @@ setup_for_next:
>         if (card->rx_cmd_ep == context->ep) {
>                 mwifiex_usb_submit_rx_urb(context, size);
>         } else {
> -               if (atomic_read(&adapter->rx_pending) <= HIGH_RX_PENDING){
> +               if (atomic_read(&adapter->rx_pending) <= HIGH_RX_PENDING) {
>                         mwifiex_usb_submit_rx_urb(context, size);
> -               }else{
> +               } else {
>                         context->skb = NULL;
>                 }
>         }
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
