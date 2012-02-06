Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38626 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab2BFQbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 11:31:31 -0500
Date: Mon, 6 Feb 2012 11:16:52 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Rick Farina <sidhayn@gmail.com>
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] add missing =y to CONFIG_RT2X00_LIB_DEBUGFS
Message-ID: <20120206161652.GB21048@tuxdriver.com> (sfid-20120206_173135_357822_6232DD62)
References: <1328542936-20963-1-git-send-email-sidhayn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1328542936-20963-1-git-send-email-sidhayn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 06, 2012 at 10:42:16AM -0500, Rick Farina wrote:
> When editing config.mk with a sed script the missing =y on this line
> causes issue. Since this line is commented out by default this means no
> changes to the default behavior and sed scripts will be able to edit the
> config.mk file much more easily.
> 
> Signed-of-By: Rick Farina <sidhayn@gmail.com>
> ---
>  config.mk |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/config.mk b/config.mk
> index 9433ce9..a9d189e 100644
> --- a/config.mk
> +++ b/config.mk
> @@ -639,7 +639,7 @@ CONFIG_RT2X00_LIB_LEDS=y
>  endif #CONFIG_LEDS_CLASS
>  endif #CONFIG_COMPAT_KERNEL_2_6_25
>  # CONFIG_RT2X00_DEBUG=y
> -# CONFIG_RT2X00_LIB_DEBUGFS
> +# CONFIG_RT2X00_LIB_DEBUGFS=y
>  endif
>  
>  # p54

Isn't it more common to say "is not set" for Kconfig stuff that is commented out?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
