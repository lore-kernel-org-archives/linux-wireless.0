Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:49409 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbZAVRmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 12:42:05 -0500
Received: by gxk14 with SMTP id 14so3950339gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 09:42:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1232631861-6028-5-git-send-email-me@bobcopeland.com>
References: <1232631861-6028-5-git-send-email-me@bobcopeland.com>
Date: Thu, 22 Jan 2009 19:42:04 +0200
Message-ID: <40f31dec0901220942x97d482el7343a35f61e955cd@mail.gmail.com> (sfid-20090122_184210_941985_F9956D87)
Subject: Re: [PATCH 4/6] ath5k: remove unused led_off parameter
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/22 Bob Copeland <me@bobcopeland.com>:
> ath5k_softc->led_off hasn't been used since commit
> 3a078876caee9634dbb9b41e6269262e30e8b535, "convert LED code to use
> mac80211 triggers."
>
> Changes-licensed-under: 3-Clause-BSD
>
> Reported-by: Tobias Doerffel <tobias.doerffel@gmail.com>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/base.h |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
> index facc60d..c0fb8b5 100644
> --- a/drivers/net/wireless/ath5k/base.h
> +++ b/drivers/net/wireless/ath5k/base.h
> @@ -148,8 +148,7 @@ struct ath5k_softc {
>        u8                      bssidmask[ETH_ALEN];
>
>        unsigned int            led_pin,        /* GPIO pin for driving LED */
> -                               led_on,         /* pin setting for LED on */
> -                               led_off;        /* off time for current blink */
> +                               led_on;         /* pin setting for LED on */
>
>        struct tasklet_struct   restq;          /* reset tasklet */
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
