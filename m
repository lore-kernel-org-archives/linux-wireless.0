Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:65489 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609AbZGPNok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 09:44:40 -0400
Received: by bwz28 with SMTP id 28so125250bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 06:44:39 -0700 (PDT)
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] wl12xx: loop off by one.
References: <4A524E91.9040400@gmail.com> <4A5F02C9.50505@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Jul 2009 16:44:35 +0300
In-Reply-To: <4A5F02C9.50505@gmail.com> (Roel Kluin's message of "Thu\, 16 Jul 2009 12\:36\:57 +0200")
Message-ID: <87ws684u9o.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Roel Kluin <roel.kluin@gmail.com> writes:

> With `while (loop++ < INIT_LOOP)' `loop' becomes INIT_LOOP + 1 after
> the loop.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>>> with `while (loop++ < INIT_LOOP)' `loop' reaches -1 after the loop.
>>
>> Sorry, my brains are on vacation mode right now and I can't understand
>> how loop can reach -1.
>
> The confusion is my fault. The changelog should have as above. The patch
> is correct though.

Ah. Thanks for explaining this to me, I understand this now. Good catch,
thanks for fixing this.

Acked-by: Kalle Valo <kalle.valo@nokia.com>

John, please take this patch. Please holler if we need to resend it.

-- 
Kalle Valo
