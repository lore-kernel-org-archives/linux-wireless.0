Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:15098 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbZASNsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 08:48:35 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2620779rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 05:48:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4973B233.9040902@gmail.com>
References: <4973B233.9040902@gmail.com>
Date: Mon, 19 Jan 2009 08:48:34 -0500
Message-ID: <b6c5339f0901190548n2a390ab4n8501a22cb47a0078@mail.gmail.com> (sfid-20090119_144839_251086_026C5E94)
Subject: Re: [PATCH] ath5k: notice a negative keytype
From: Bob Copeland <me@bobcopeland.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 18, 2009 at 5:50 PM, Roel Kluin <roel.kluin@gmail.com> wrote:
> To notice a negative keytype
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Bob Copeland <me@bobcopeland.com>

> ---
> diff --git a/drivers/net/wireless/ath5k/pcu.c b/drivers/net/wireless/ath5k/pcu.c
> index 75eb9f4..5bb8a02 100644
> --- a/drivers/net/wireless/ath5k/pcu.c
> +++ b/drivers/net/wireless/ath5k/pcu.c
> @@ -1041,7 +1041,7 @@ int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
>        __le32 key_v[5] = {};
>        __le32 key0 = 0, key1 = 0;
>        __le32 *rxmic, *txmic;
> -       u32 keytype;
> +       int keytype;
>        u16 micentry = entry + AR5K_KEYTABLE_MIC_OFFSET;
>        bool is_tkip;
>        const u8 *key_ptr;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Bob Copeland %% www.bobcopeland.com
