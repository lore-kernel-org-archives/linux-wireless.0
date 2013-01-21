Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:50414 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab3AUUUd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 15:20:33 -0500
Received: by mail-qc0-f173.google.com with SMTP id b12so26775qca.32
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jan 2013 12:20:32 -0800 (PST)
Message-ID: <50FDA355.7090400@gmail.com> (sfid-20130121_212036_951515_93970258)
Date: Mon, 21 Jan 2013 15:21:41 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [ANN] crda: v1.1.3
References: <E1TwInB-0003VY-Jh@sipsolutions.net> <50FA04B6.8080703@gmail.com> <CAB=NE6UHBZhg7L_Oh5EayLBQyY=fceqUBtfz=kEFXG_u2Ko9TQ@mail.gmail.com> <20130121200610.GE1432@bombadil.infradead.org>
In-Reply-To: <20130121200610.GE1432@bombadil.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/21/2013 03:06 PM, Luis R. Rodriguez wrote:
> diff --git a/reglib.c b/reglib.c
> index bc81974..1fafd37 100644
> --- a/reglib.c
> +++ b/reglib.c
> @@ -9,6 +9,7 @@
>  #include <fcntl.h>
>  #include <stdbool.h>
>  #include <unistd.h>
> +#include <string.h>
>  
>  #include <arpa/inet.h> /* ntohl */

This patch fixes the warnings, thank you.

Normally warnings are not a big deal, but often they later become errors
so I figured it was worth reporting. Glad to see it fixed ;-)

Thanks,
Zero
