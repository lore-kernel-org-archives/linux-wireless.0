Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:45120 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0CXWNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 18:13:45 -0400
Received: by ewy8 with SMTP id 8so127383ewy.28
        for <linux-wireless@vger.kernel.org>; Wed, 24 Mar 2010 15:13:44 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 1/2] rt2x00: Fix typo in RF register programming of rt2800.
Date: Wed, 24 Mar 2010 23:13:40 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1269463357-32563-1-git-send-email-gwingerde@gmail.com> <1269463357-32563-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1269463357-32563-2-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <201003242313.41180.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 24 March 2010, Gertjan van Wingerde wrote:
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 18d4d8e..326fce7 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -812,9 +812,9 @@ static void rt2800_config_channel_rt3x(struct rt2x00_dev *rt2x00dev,
>  	rt2800_rfcsr_write(rt2x00dev, 24,
>  			      rt2x00dev->calibration[conf_is_ht40(conf)]);
>  
> -	rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
> +	rt2800_rfcsr_read(rt2x00dev, 7, &rfcsr);
>  	rt2x00_set_field8(&rfcsr, RFCSR7_RF_TUNING, 1);
> -	rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
> +	rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
>  }
>  
>  static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,


