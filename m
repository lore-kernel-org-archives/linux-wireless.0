Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39407 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab2ACPpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 10:45:53 -0500
Date: Tue, 3 Jan 2012 10:35:36 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Luis Rodriguez <mcgrof@frijolero.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: compat-wireless patch Re: [PATCH] Enable
 CONFIG_RT2800{PCI,USB}_RT53XX
Message-ID: <20120103153535.GA24318@tuxdriver.com> (sfid-20120103_164557_290815_8A9415DD)
References: <1325604516-14280-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1325604516-14280-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 03, 2012 at 10:28:36AM -0500, John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> Any reason to treat these differently than the RT35XX devices?

Obviously, this is a compat-wireless patch -- duh! :-)

John

> 
>  config.mk |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/config.mk b/config.mk
> index e44b814..4d2ad5c 100644
> --- a/config.mk
> +++ b/config.mk
> @@ -393,7 +393,7 @@ ifdef CONFIG_CRC_CCITT
>  CONFIG_RT2800PCI=m
>  CONFIG_RT2800PCI_RT33XX=y
>  CONFIG_RT2800PCI_RT35XX=y
> -# CONFIG_RT2800PCI_RT53XX=y
> +CONFIG_RT2800PCI_RT53XX=y
>  endif #CONFIG_CRC_CCITT
>  NEED_RT2X00=y
>  
> @@ -523,7 +523,7 @@ ifdef CONFIG_CRC_CCITT
>  CONFIG_RT2800USB=m
>  CONFIG_RT2800USB_RT33XX=y
>  CONFIG_RT2800USB_RT35XX=y
> -# CONFIG_RT2800USB_RT53XX=y
> +CONFIG_RT2800USB_RT53XX=y
>  CONFIG_RT2800USB_UNKNOWN=y
>  endif #CONFIG_CRC_CCITT
>  CONFIG_RT2X00_LIB_USB=m
> -- 
> 1.7.4.4
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
