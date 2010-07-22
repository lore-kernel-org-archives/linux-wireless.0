Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab0GVU1U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 16:27:20 -0400
Subject: Re: [PATCH] MAINTAINERS: orphan the atmel wireless driver
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Simon Kelley <simon@thekelleys.org.uk>
In-Reply-To: <1279823468-21366-1-git-send-email-linville@tuxdriver.com>
References: <1279823468-21366-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 15:28:41 -0700
Message-ID: <1279837721.4829.19.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-22 at 14:31 -0400, John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Aww,  how sad :(.  I'll take it since I still have some of this
hardware.  Not that I'll do much with it, but if the patches are simple
I'm happy to test+ack them.

Dan

>  MAINTAINERS |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3148b71..2911648 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1170,11 +1170,10 @@ S:	Supported
>  F:	drivers/usb/gadget/atmel_usba_udc.*
>  
>  ATMEL WIRELESS DRIVER
> -M:	Simon Kelley <simon@thekelleys.org.uk>
>  L:	linux-wireless@vger.kernel.org
>  W:	http://www.thekelleys.org.uk/atmel
>  W:	http://atmelwlandriver.sourceforge.net/
> -S:	Maintained
> +S:	Orphan
>  F:	drivers/net/wireless/atmel*
>  
>  AUDIT SUBSYSTEM


