Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44858 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2DSCv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 22:51:57 -0400
Received: by obbta14 with SMTP id ta14so7484111obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 19:51:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj987y9787pA-NzU6XTct7=WMhi-UwV24BUHJTri2Bs2-3nw@mail.gmail.com>
References: <4F630AEA.10703@etit.tu-chemnitz.de> <20120316204547.GG18861@tux>
 <4F63BA31.1080608@etit.tu-chemnitz.de> <4F856449.3000804@etit.tu-chemnitz.de>
 <1334203508.3788.12.camel@jlt3.sipsolutions.net> <4F868732.1030401@etit.tu-chemnitz.de>
 <1334714536.3725.33.camel@jlt3.sipsolutions.net> <CAPjQAd99vzQDO0PzC-0jq1j8h4ekQAP_dRE=g5f=w=6EwcXrDw@mail.gmail.com>
 <4F8ED849.4020002@sipsolutions.net> <CAPjQAd-4djbAuWtNsALa3n7xBWX1dN9K1wYrF-bPzj6j6fT4jg@mail.gmail.com>
 <CAEFj987y9787pA-NzU6XTct7=WMhi-UwV24BUHJTri2Bs2-3nw@mail.gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 18 Apr 2012 19:51:36 -0700
Message-ID: <CAPjQAd9HXS+0DkLeUcn=aHUr8cnkFu7FzC5_7J49Hn7h8q6waA@mail.gmail.com> (sfid-20120419_045201_098441_5BF5341B)
Subject: Re: [Greenmesh] [ath9k] mesh powersave hardware sleep + wakeup
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, henry@logout.com,
	"greenmesh@lists.osll.spb.ru" <greenmesh@lists.osll.spb.ru>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 18, 2012 at 7:41 PM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
>> Now we know what hardware *not* to use for this :P
> What is the hardware that you referred to?
>
> Please advice. Thanks

Johannes was just explaining that Intel wlan devices would not report
timing info in the way required for mesh synchronization.  Not a big
deal considering that they don't support mesh mode.
My comment should have been interpreted as a joke (and probably I
should have sent it off-list, sorry!).

Javier

> On Wed, Apr 18, 2012 at 11:16 PM, Javier Cardona <javier@cozybit.com> wrote:
>> On Wed, Apr 18, 2012 at 8:05 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>> On 4/18/2012 7:56 AM, Javier Cardona wrote:
>>>>
>>>> On Tue, Apr 17, 2012 at 7:02 PM, Johannes Berg
>>>> <johannes@sipsolutions.net>  wrote:
>>>>>
>>>>> (...)
>>>>> Keep in mind that TSF == start of TSF field, while rx_status->timestamp
>>>>> == start of first symbol, which I didn't even remember when you guys did
>>>>> all the Toffset things, I'm guessing they're all wrong :-)
>>>>
>>>>
>>>> I think you guessed wrong :)
>>>
>>>
>>> Nice! FWIW, our hardware (not that the driver supports mesh now) will give
>>> the timestamp at the first symbol of the MPDU, so some more offset
>>> calculations are needed and we don't give valid timestamps today. I started
>>> working on this but haven't figured out HT preamble duration yet.
>>
>> Thanks for letting us know.  Now we know what hardware *not* to use for this :P
>>
>> Javier
>> _______________________________________________
>> Greenmesh mailing list
>> Greenmesh@lists.osll.spb.ru
>> http://lists.osll.spb.ru/mailman/listinfo/greenmesh



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
