Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:43217 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbZHNR1p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 13:27:45 -0400
Received: by bwz22 with SMTP id 22so1267086bwz.18
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 10:27:45 -0700 (PDT)
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Spare warnings - wireless drivers
References: <43e72e890908131331q371320a3gf1ab53ea27574549@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 14 Aug 2009 20:21:49 +0300
In-Reply-To: <43e72e890908131331q371320a3gf1ab53ea27574549@mail.gmail.com> (Luis R. Rodriguez's message of "Thu\, 13 Aug 2009 13\:31\:18 -0700")
Message-ID: <87ws56z4ya.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@gmail.com> writes:

> TI:
>
>   CHECK   drivers/net/wireless/wl12xx/wl1251_boot.c
> drivers/net/wireless/wl12xx/wl1251_boot.c:227:22: warning: symbol
> 'interrupt' shadows an earlier one
> /home/mcgrof/wireless-testing/arch/x86/include/asm/hw_irq.h:120:13:
> originally declared here
>
>   CHECK   drivers/net/wireless/wl12xx/wl1251_sdio.c
> drivers/net/wireless/wl12xx/wl1251_sdio.c:68:6: warning: symbol
> 'wl1251_sdio_read' was not declared. Should it be static?
> drivers/net/wireless/wl12xx/wl1251_sdio.c:80:6: warning: symbol
> 'wl1251_sdio_write' was not declared. Should it be static?
> drivers/net/wireless/wl12xx/wl1251_sdio.c:92:6: warning: symbol
> 'wl1251_sdio_reset' was not declared. Should it be static?
> drivers/net/wireless/wl12xx/wl1251_sdio.c:114:6: warning: symbol
> 'wl1251_sdio_set_power' was not declared. Should it be static?
> drivers/net/wireless/wl12xx/wl1251_sdio.c:118:29: warning: symbol
> 'wl1251_sdio_ops' was not declared. Should it be static?
> drivers/net/wireless/wl12xx/wl1251_sdio.c:126:5: warning: symbol
> 'wl1251_sdio_probe' was not declared. Should it be static?

Thanks. I'll fix these.

-- 
Kalle Valo
