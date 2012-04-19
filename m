Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52633 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2DSCld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 22:41:33 -0400
Received: by iagz16 with SMTP id z16so11269857iag.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 19:41:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPjQAd-4djbAuWtNsALa3n7xBWX1dN9K1wYrF-bPzj6j6fT4jg@mail.gmail.com>
References: <4F630AEA.10703@etit.tu-chemnitz.de>
	<20120316204547.GG18861@tux>
	<4F63BA31.1080608@etit.tu-chemnitz.de>
	<4F856449.3000804@etit.tu-chemnitz.de>
	<1334203508.3788.12.camel@jlt3.sipsolutions.net>
	<4F868732.1030401@etit.tu-chemnitz.de>
	<1334714536.3725.33.camel@jlt3.sipsolutions.net>
	<CAPjQAd99vzQDO0PzC-0jq1j8h4ekQAP_dRE=g5f=w=6EwcXrDw@mail.gmail.com>
	<4F8ED849.4020002@sipsolutions.net>
	<CAPjQAd-4djbAuWtNsALa3n7xBWX1dN9K1wYrF-bPzj6j6fT4jg@mail.gmail.com>
Date: Thu, 19 Apr 2012 10:41:33 +0800
Message-ID: <CAEFj987y9787pA-NzU6XTct7=WMhi-UwV24BUHJTri2Bs2-3nw@mail.gmail.com> (sfid-20120419_044141_218755_2E09AFD3)
Subject: Re: [Greenmesh] [ath9k] mesh powersave hardware sleep + wakeup
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Javier Cardona <javier@cozybit.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, henry@logout.com,
	"greenmesh@lists.osll.spb.ru" <greenmesh@lists.osll.spb.ru>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Javier

> Now we know what hardware *not* to use for this
What is the hardware that you referred to?

Please advice. Thanks

Regards,
Chun-Yeow


On Wed, Apr 18, 2012 at 11:16 PM, Javier Cardona <javier@cozybit.com> wrote:
> On Wed, Apr 18, 2012 at 8:05 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On 4/18/2012 7:56 AM, Javier Cardona wrote:
>>>
>>> On Tue, Apr 17, 2012 at 7:02 PM, Johannes Berg
>>> <johannes@sipsolutions.net>  wrote:
>>>>
>>>> (...)
>>>> Keep in mind that TSF == start of TSF field, while rx_status->timestamp
>>>> == start of first symbol, which I didn't even remember when you guys did
>>>> all the Toffset things, I'm guessing they're all wrong :-)
>>>
>>>
>>> I think you guessed wrong :)
>>
>>
>> Nice! FWIW, our hardware (not that the driver supports mesh now) will give
>> the timestamp at the first symbol of the MPDU, so some more offset
>> calculations are needed and we don't give valid timestamps today. I started
>> working on this but haven't figured out HT preamble duration yet.
>
> Thanks for letting us know.  Now we know what hardware *not* to use for this :P
>
> Javier
> _______________________________________________
> Greenmesh mailing list
> Greenmesh@lists.osll.spb.ru
> http://lists.osll.spb.ru/mailman/listinfo/greenmesh
