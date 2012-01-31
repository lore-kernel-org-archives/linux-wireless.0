Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:42462 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619Ab2AaWwD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 17:52:03 -0500
Received: by obcva7 with SMTP id va7so527847obc.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 14:52:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327618544-23163-1-git-send-email-hauke@hauke-m.de>
References: <1327618544-23163-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 31 Jan 2012 14:51:43 -0800
Message-ID: <CAB=NE6VpEuBT8tzGGTz0DKCzSgxJHW3xwQuOchGLzWj2uhZ2uw@mail.gmail.com> (sfid-20120131_235208_475586_F05B35AD)
Subject: Re: [PATCH] compat-wireless: fix some config options
To: Hauke Mehrtens <hauke@hauke-m.de>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 26, 2012 at 2:55 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> Adds some missing config options interceded in the last time and remove
> some old now unused config options.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  config.mk |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/config.mk b/config.mk
> index 4d2ad5c..9433ce9 100644
> --- a/config.mk
> +++ b/config.mk
> @@ -281,6 +281,8 @@ CONFIG_ATH9K_COMMON=m
>  # for long range considerations.
>  CONFIG_ATH9K_RATE_CONTROL=y
>
> +CONFIG_ATH9K_BTCOEX_SUPPORT=y

Senthil, just a heads up. Given that the default in Kconfig is "y" I
will apply this patch. Not sure if we should also apply it to the
stable compat-wireless series.

  Luis
