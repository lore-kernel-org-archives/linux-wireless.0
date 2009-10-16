Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:44587 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbZJPIid (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 04:38:33 -0400
Received: by ewy4 with SMTP id 4so1356405ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 01:37:55 -0700 (PDT)
To: John Willis <John.Willis@Distant-earth.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville\@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH] wl1251: add support for PG11 chips.
References: <01c201ca4d9c$c2c44500$484ccf00$@Willis@Distant-earth.com>
	<87vdifbyao.fsf@nokia.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 16 Oct 2009 11:37:53 +0300
In-Reply-To: <87vdifbyao.fsf@nokia.com> (Kalle Valo's message of "Fri\, 16 Oct 2009 10\:19\:59 +0300")
Message-ID: <87my3rn38e.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

> John Willis <John.Willis@Distant-earth.com> writes:
>
>> From: David-John Willis <John.Willis@Distant-earth.com>
>>
>> This simple patch adds support for the PG11 variant of the WL1251 chip as
>> used on the OpenPandora OMAP3 device.
>>
>> Signed-off-by: David-John Willis <John.Willis@Distant-earth.com>

[...]

> This patch also enables PG10 support, but as that hardware revision is
> untested I think it's better not to enable it. I'll edit the patch a bit
> regarding this and then send it to John.

Oh, I noticed that Linville had already applied your patch. I'll send
a patch on top of this to fix the issue.

Linville, is this ok for you?

Too many Johns here :)

-- 
Kalle Valo
