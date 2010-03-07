Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:25659 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab0CGRwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Mar 2010 12:52:47 -0500
Received: by fg-out-1718.google.com with SMTP id 16so2090662fgg.1
        for <linux-wireless@vger.kernel.org>; Sun, 07 Mar 2010 09:52:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87d3zgdolb.fsf@purkki.valot.fi>
References: <20100202000934.GA19847@sortiz.org> <201002151146.48156.holgerschurig@gmail.com>
	<cdd918981002240005o1fa50956yfb2a692716c06a55@mail.gmail.com>
	<1267054502.6162.9.camel@localhost.localdomain> <cdd918981002250042m16cdf34ap8305ed2fbfd7804d@mail.gmail.com>
	<1267087684.3796.0.camel@jlt3.sipsolutions.net> <c1545bb51002251005o396130e9g906e5efff024c78@mail.gmail.com>
	<87d3zgdolb.fsf@purkki.valot.fi>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 7 Mar 2010 18:52:25 +0100
Message-ID: <69e28c911003070952g4a4a1bddo47affe3c63d27f3a@mail.gmail.com>
Subject: Re: [PATCH] libertas: cfg80211 support
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Andrey Yurovsky <yurovsky@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	David MOUSSAUD <d.moussaud@gmail.com>,
	Dan Williams <dcbw@redhat.com>,
	Holger Schurig <holgerschurig@gmail.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Holger Schurig <holgerschurig@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 7, 2010 at 6:32 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Andrey Yurovsky <yurovsky@gmail.com> writes:
>
>>>> Do you know an other sdio chipset that would do the job ?
>>>
>>> libertas_tf driver has AP iirc.
>>
>> Yes but it only supports one variant with USB (88w8388) and special
>> firmware, there's no SDIO equivalent.
>>
>> The only soft-MAC/mac80211 hardware/driver that I can think of that
>> has an SDIO variant right now is the TI wl12xx stuff but I don't know
>> anything about it or whether it can do enough to support AP via
>> mac80211.
>
> wl1251 at least doesn't support AP mode. Maybe it's possible to hack
> something in the driver, but because firmware doesn't support it it
> would be incomplete anyway.
>
> --
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

B43 also has SDIO support, and AFAIK AP mode also works (though not
sure if you can use AP mode on an SDIO card). The only problem is
finding an SDIO card with a Broadcom chipset.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
