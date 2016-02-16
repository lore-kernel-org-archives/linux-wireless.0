Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:33296 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbcBPF4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 00:56:53 -0500
Received: by mail-ig0-f196.google.com with SMTP id hb3so7949404igb.0
        for <linux-wireless@vger.kernel.org>; Mon, 15 Feb 2016 21:56:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1455173229-6383-3-git-send-email-royujjal@gmail.com>
References: <1455173229-6383-1-git-send-email-royujjal@gmail.com>
	<1455173229-6383-3-git-send-email-royujjal@gmail.com>
Date: Tue, 16 Feb 2016 11:26:52 +0530
Message-ID: <CAFqt6zbpn2-RDeKi_C0qj9xE5W-b17-OPviBZ1NYKixnKzJHAQ@mail.gmail.com> (sfid-20160216_065707_094254_387AF41B)
Subject: Re: [PATCH 3/3] mwifiex: Added missing spaces around brackets
From: Souptick Joarder <jrdr.linux@gmail.com>
To: Ujjal Roy <royujjal@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks fine.

On Thu, Feb 11, 2016 at 12:17 PM, Ujjal Roy <royujjal@gmail.com> wrote:
> This patch fixes the missing spaces issue in coding style.
>
> Signed-off-by: Ujjal Roy <royujjal@gmail.com>
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

-Souptick
