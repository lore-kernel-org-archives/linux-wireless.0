Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:63229 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbZDOMZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 08:25:53 -0400
Received: by rv-out-0506.google.com with SMTP id f9so3069327rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 05:25:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49E5C2A9.4050707@gmx.de>
References: <49E5C2A9.4050707@gmx.de>
Date: Wed, 15 Apr 2009 17:55:52 +0530
Message-ID: <1fe543780904150525t4b18d3c0t32a307a6373c3883@mail.gmail.com> (sfid-20090415_142556_216634_EA130398)
Subject: Re: SDIO_DEVICE_ID_MARVELL_8688WLAN not declared (snapshot
	15.04.2009)
From: Kiran Divekar <kirandivekar@gmail.com>
To: ZeroBeat <ZeroBeat@gmx.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 15, 2009 at 4:49 PM, ZeroBeat <ZeroBeat@gmx.de> wrote:
> Hello Gentlemen.
>
> gcc reports an error during the compilation:
>
> compat-wireless-2009-04-15/drivers/net/wireless/libertas/if_sdio.c
> ERROR 53:
> =BBSDIO_DEVICE_ID_MARVELL_8688WLAN=AB
> not declared
>

Hi,
 Please check include/linux/mmc/sdio_ids.h file which has the
corresponding definition. If you still see the error, can you please
post .config file

Thanks
- Kiran
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
