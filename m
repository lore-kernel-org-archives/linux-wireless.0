Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:38396 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbZJPQGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 12:06:04 -0400
Received: by ewy4 with SMTP id 4so1736420ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 09:05:27 -0700 (PDT)
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Greg KH <greg@kroah.com>,
	"devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] staging/stlc45xx: Fix compile error
References: <1255575825.10636.17.camel@laptop> <87zl7rbyl2.fsf@nokia.com>
	<390803460910160711i5f7edcc3ue737c05a8b1495b1@mail.gmail.com>
	<200910161654.29933.chunkeey@googlemail.com>
	<390803460910160859m6364219fx59fe067432a4942e@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 16 Oct 2009 19:05:25 +0300
In-Reply-To: <390803460910160859m6364219fx59fe067432a4942e@mail.gmail.com> (Javier Martinez Canillas's message of "Fri\, 16 Oct 2009 11\:59\:04 -0400")
Message-ID: <87iqefmiii.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Javier Martinez Canillas <martinez.javier@gmail.com> writes:

>>> At least I could make it compile when the API changes and work on bugs
>>> reported until you are confident that p54spi driver is good enough and
>>> there is no need anymore for stlc45xx.
>>
>> p54spi IS stlc45xx, but with a different name.
>
> In that case I guess probably the best option would be to remove
> stlc45xx from staging as Kalle sugested. Users should migrate to
> p54spi since it is already in /net/wireless/

Yes, p54spi is the future. If you have spare time, better to work on
p54spi instead of stlc45xx.

-- 
Kalle Valo
