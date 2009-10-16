Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f172.google.com ([209.85.221.172]:40347 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759429AbZJPP7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 11:59:55 -0400
Received: by qyk2 with SMTP id 2so1565495qyk.21
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 08:59:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910161654.29933.chunkeey@googlemail.com>
References: <1255575825.10636.17.camel@laptop> <87zl7rbyl2.fsf@nokia.com>
	<390803460910160711i5f7edcc3ue737c05a8b1495b1@mail.gmail.com>
	<200910161654.29933.chunkeey@googlemail.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Fri, 16 Oct 2009 11:59:04 -0400
Message-ID: <390803460910160859m6364219fx59fe067432a4942e@mail.gmail.com>
Subject: Re: [PATCH 1/1] staging/stlc45xx: Fix compile error
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, Greg KH <greg@kroah.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> At least I could make it compile when the API changes and work on bugs
>> reported until you are confident that p54spi driver is good enough and
>> there is no need anymore for stlc45xx.
>
> p54spi IS stlc45xx, but with a different name.
>

In that case I guess probably the best option would be to remove
stlc45xx from staging as Kalle sugested. Users should migrate to
p54spi since it is already in /net/wireless/

Best regards

-----------------------------------------
Javier Martínez Canillas
+595 981 88 66 58
