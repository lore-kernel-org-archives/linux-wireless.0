Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33953 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab2H0IXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 04:23:38 -0400
Received: by vcbfk26 with SMTP id fk26so4108975vcb.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Aug 2012 01:23:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345989412.8762.6.camel@mehome>
References: <20120820205355.7ccc0450@emcraft.com>
	<20120821114343.GB2380@redhat.com>
	<1345989412.8762.6.camel@mehome>
Date: Mon, 27 Aug 2012 10:23:37 +0200
Message-ID: <CAOZOX0UsnFg_ZKcpR3h-wP+3AuO42Qyro2VRosgkuwjzX7-OSg@mail.gmail.com> (sfid-20120827_102341_326000_15281149)
Subject: Re: [rt2x00-users] [PATCH] compat-wireless:rt2800usb: Fixed a typo
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Sergei Poselenov <sposelenov@emcraft.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 26, 2012 at 3:56 PM, Sergei Poselenov
<sposelenov@emcraft.com> wrote:
> Fixed a typo in the comment.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 6cf3365..f8085b2 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -662,7 +662,7 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
>         rx_pkt_len = rt2x00_get_field32(word, RXINFO_W0_USB_DMA_RX_PKT_LEN);
>
>         /*
> -        * Remove the RXINFO structure from the sbk.
> +        * Remove the RXINFO structure from the skb.
>          */
>         skb_pull(entry->skb, RXINFO_DESC_SIZE);
>
> --
> 1.7.4.4
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
