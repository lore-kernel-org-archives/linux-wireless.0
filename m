Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:38849 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430Ab0CLKCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 05:02:39 -0500
Received: by fg-out-1718.google.com with SMTP id 16so461215fgg.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Mar 2010 02:02:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87zl2ecanr.fsf@purkki.valot.fi>
References: <1268322276-16640-1-git-send-email-notasas@gmail.com>
	 <87zl2ecanr.fsf@purkki.valot.fi>
Date: Fri, 12 Mar 2010 12:02:36 +0200
Message-ID: <6ed0b2681003120202j693b756s6aaaf365008434ae@mail.gmail.com>
Subject: Re: [PATCH 1/4] wl1251: make local symbols static
From: Grazvydas Ignotas <notasas@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 12, 2010 at 8:32 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Grazvydas Ignotas <notasas@gmail.com> writes:
>
>> Make local functions and data static, also constify
>> some structures. While at it, clean up unneeded includes.
>>
>> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
>> Cc: Bob Copeland <me@bobcopeland.com>
>
> Thanks. Looks good, but...
>
>> -#include <linux/mod_devicetable.h>
>
> ...this is needed for struct sdio_device_id AFAICS. If you can send a
> new version which keeps that include, you'll have my acked-by.

That one comes through linux/mmc/sdio_func.h , but I'll add it back
for completeness and resend, thanks.
