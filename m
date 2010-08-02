Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55982 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab0HBSBN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 14:01:13 -0400
Received: by gwb20 with SMTP id 20so1352556gwb.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 11:01:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1280700173-14690-4-git-send-email-kkhere.geo@gmail.com>
References: <4C55D22A.5040302@hauke-m.de> <1280700173-14690-4-git-send-email-kkhere.geo@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 2 Aug 2010 11:00:52 -0700
Message-ID: <AANLkTinfrBRm8J2G+k8bB6N-YniVkmUYOBkRpyF_tC2j@mail.gmail.com>
Subject: Re: [PATCH 3/3] compat: define struct va_format introduced in v2.6.36
To: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 1, 2010 at 3:02 PM, Kshitij Kulshreshtha
<kkhere.geo@gmail.com> wrote:
> Signed-off-by: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
> ---
>  include/linux/compat-2.6.36.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
> index 0307108..b14c772 100644
> --- a/include/linux/compat-2.6.36.h
> +++ b/include/linux/compat-2.6.36.h
> @@ -8,6 +8,11 @@
>  #define kparam_block_sysfs_write(a)
>  #define kparam_unblock_sysfs_write(a)
>
> +struct va_format {
> +       const char *fmt;
> +       va_list *va;
> +};
> +
>  #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
>
>  #endif /* LINUX_26_36_COMPAT_H */

I'll apply this for now but what caller uses this for example?

  Luis
