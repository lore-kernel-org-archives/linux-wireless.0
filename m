Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.nanl.de ([217.115.11.12]:56765 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab3BFObj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 09:31:39 -0500
Received: from mail-ia0-f172.google.com (mail-ia0-f172.google.com [209.85.210.172])
	by mail.nanl.de (Postfix) with ESMTPSA id 2CFBB45EC3
	for <linux-wireless@vger.kernel.org>; Wed,  6 Feb 2013 14:30:18 +0000 (UTC)
Received: by mail-ia0-f172.google.com with SMTP id u8so1621011iag.31
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2013 06:31:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130103075440.GA20523@markyou.marvell.com>
References: <20130103075440.GA20523@markyou.marvell.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Wed, 6 Feb 2013 15:31:12 +0100
Message-ID: <CAOiHx=kpV8TScc4gQRZUBwUDAEL-j+uoNg3eodKi8WwmAHYg=w@mail.gmail.com> (sfid-20130206_153142_189102_9408A768)
Subject: Re: [PATCH 5/5] mwl8k: bump firmware API to 3
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 January 2013 08:54, Yogesh Ashok Powar <yogeshp@marvell.com> wrote:
> New firmware is required to support
> a) Add support for additional ampdu streams
> b) Handle corresponding watchdog events to destroy ampdu streams
>
> Bumping firmware API version by one.

Soo ... where does one get this new firmware version? I don't see it
anywhere (especially not in linux-firmware.git). AFAICT mwl8k in
ap-mode is currently broken since this patch got in.

> Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
> Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
> ---
>  drivers/net/wireless/mwl8k.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
> index 51ae9e9..5717e15 100644
> --- a/drivers/net/wireless/mwl8k.c
> +++ b/drivers/net/wireless/mwl8k.c
> @@ -5319,7 +5319,7 @@ enum {
>         MWL8366,
>  };
>
> -#define MWL8K_8366_AP_FW_API 2
> +#define MWL8K_8366_AP_FW_API 3
>  #define _MWL8K_8366_AP_FW(api) "mwl8k/fmimage_8366_ap-" #api ".fw"
>  #define MWL8K_8366_AP_FW(api) _MWL8K_8366_AP_FW(api)
>
> --
> 1.8.0.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
