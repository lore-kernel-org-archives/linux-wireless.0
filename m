Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32982 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab0HSNtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Aug 2010 09:49:22 -0400
Received: by iwn1 with SMTP id 1so117037iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Aug 2010 06:49:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282197045-4473-2-git-send-email-vnatarajan@atheros.com>
References: <1282197045-4473-1-git-send-email-vnatarajan@atheros.com> <1282197045-4473-2-git-send-email-vnatarajan@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 18 Aug 2010 23:51:27 -0700
Message-ID: <AANLkTinQU+WVRJoQeM7Bs320LOe+_y968tcXf78crfU-@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] ath9k_htc: Add support for bluetooth coexistence.
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 18, 2010 at 10:50 PM, Vivek Natarajan
<vnatarajan@atheros.com> wrote:

> --- a/drivers/net/wireless/ath/ath9k/htc.h
> +++ b/drivers/net/wireless/ath/ath9k/htc.h
> @@ -316,17 +316,32 @@ struct htc_beacon_config {
>        u8 dtim_count;
>  };
>
> -#define OP_INVALID        BIT(0)
> -#define OP_SCANNING       BIT(1)
> -#define OP_FULL_RESET     BIT(2)
> -#define OP_LED_ASSOCIATED BIT(3)
> -#define OP_LED_ON         BIT(4)
> -#define OP_PREAMBLE_SHORT BIT(5)
> -#define OP_PROTECT_ENABLE BIT(6)
> -#define OP_ASSOCIATED     BIT(7)
> -#define OP_ENABLE_BEACON  BIT(8)
> -#define OP_LED_DEINIT     BIT(9)
> -#define OP_UNPLUGGED      BIT(10)

Can you get the patch to not do this?

  Luis
