Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:32922 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750794AbdH3TFJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 15:05:09 -0400
Received: by mail-wm0-f52.google.com with SMTP id r202so3634673wmd.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 12:05:08 -0700 (PDT)
Subject: Re: [PATCH 12/30] brcmfmac: Whitespace fixes.
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-13-ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <17496ac5-2186-d111-73ac-f7532b9e107e@broadcom.com> (sfid-20170830_210512_396428_1D2DC1E4)
Date: Wed, 30 Aug 2017 21:05:06 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-13-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:

Maybe mention the function you are making whitespace changes in as it 
involves only one here.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index 916f75e5e7a1..d5d2b2222cc1 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -713,6 +713,7 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
>   	int err;
>   
>   	mypkt = brcmu_pkt_buf_get_skb(nbytes);
> +
>   	if (!mypkt) {
>   		brcmf_err("brcmu_pkt_buf_get_skb failed: len %d\n",
>   			  nbytes);
> @@ -727,8 +728,8 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
>   		err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_2, addr, mypkt);
>   
>   	brcmu_pkt_buf_free_skb(mypkt);
> -	return err;
>   
> +	return err;
>   }
>   
>   int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
> 
