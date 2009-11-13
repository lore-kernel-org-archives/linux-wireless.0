Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:56095 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbZKMDRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 22:17:08 -0500
Subject: Re: [PATCH] MAINTAINERS: RFKILL - Fix pattern entry missing colon
From: Marcel Holtmann <marcel@holtmann.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1258066500.9696.7.camel@Joe-Laptop.home>
References: <1258066500.9696.7.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 04:17:15 +0100
Message-ID: <1258082235.7715.8.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8264e6b..78c5a25 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4417,7 +4417,7 @@ RFKILL
>  M:	Johannes Berg <johannes@sipsolutions.net>
>  L:	linux-wireless@vger.kernel.org
>  S:	Maintained
> -F	Documentation/rfkill.txt
> +F:	Documentation/rfkill.txt
>  F:	net/rfkill/

an obvious correct patch :)

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


