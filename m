Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:49764 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbZLVQDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 11:03:34 -0500
Received: by iwn1 with SMTP id 1so4516687iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 22 Dec 2009 08:03:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1261495204-28966-4-git-send-email-hauke@hauke-m.de>
References: <1261495204-28966-1-git-send-email-hauke@hauke-m.de>
	<1261495204-28966-4-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 22 Dec 2009 08:03:14 -0800
Message-ID: <43e72e890912220803w3665563aob918a6486f3fc546@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat: autoconf.h moved from linux/ to generated/
	with kernel 2.6.33
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 22, 2009 at 7:20 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Changed the headers, because autoconf.h moved from linux/ into generated/
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  include/linux/compat-2.6.14.h |    3 ++-
>  include/linux/compat-2.6.18.h |    3 ++-
>  include/linux/compat-2.6.19.h |    2 +-
>  include/linux/compat-2.6.21.h |    2 +-
>  include/linux/compat-2.6.22.h |    2 +-
>  include/linux/compat-2.6.23.h |    2 +-
>  include/linux/compat-2.6.24.h |    3 ++-
>  include/linux/compat-2.6.25.h |    2 +-
>  include/linux/compat-2.6.26.h |    2 +-
>  include/linux/compat-2.6.27.h |    2 +-
>  include/linux/compat-2.6.28.h |    2 +-
>  include/linux/compat-2.6.29.h |    2 +-
>  include/linux/compat-2.6.30.h |    3 ++-
>  include/linux/compat-2.6.31.h |    2 +-
>  include/linux/compat-2.6.32.h |    2 +-
>  include/linux/compat-2.6.33.h |    4 ++--
>  include/linux/compat-2.6.h    |    6 +++++-
>  17 files changed, 26 insertions(+), 18 deletions(-)
>
> diff --git a/include/linux/compat-2.6.14.h b/include/linux/compat-2.6.14.h
> index 22e7e31..c509899 100644
> --- a/include/linux/compat-2.6.14.h
> +++ b/include/linux/compat-2.6.14.h
> @@ -1,12 +1,13 @@
>  #ifndef LINUX_26_14_COMPAT_H
>  #define LINUX_26_14_COMPAT_H
>
> -#include <linux/autoconf.h>
>  #include <linux/version.h>
>
>  /* Compat work for 2.6.14 */
>  #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14))
>
> +#include <linux/autoconf.h>
> +

Would it not suffice if we just handle this on compat.h?

  Luis
