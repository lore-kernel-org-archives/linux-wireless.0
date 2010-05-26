Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47467 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab0EZVsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 17:48:05 -0400
Received: by gwaa12 with SMTP id a12so1318048gwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 14:48:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilXJHs8emXX4YNHbPq0SkuC4Z22NEh-T6mwUSHS@mail.gmail.com>
References: <AANLkTimltZSc8dJPPBCibcGDaOPcQRU_5kSbenIAdi_6@mail.gmail.com>
	<AANLkTimaLEQYH4Y7HO4Fv4zT8w8AsPkaAQtk9EauX4Bt@mail.gmail.com>
	<AANLkTikRt1fUgngBQxEoEFe1VDrYVFRAoMSR53et7gxf@mail.gmail.com>
	<AANLkTim-A_TWT-flrW88gJGan47Xhm7llyrQE3ehDKU6@mail.gmail.com>
	<AANLkTim4zLxIQH2r76WZRh9kNigVNAngcK1d9-Cu65Ag@mail.gmail.com>
	<AANLkTimH3p-dBA_6ee2a0iCnPDhtPZONzCEVkzMHrUWo@mail.gmail.com>
	<AANLkTim-4UNn8acYvF7AF2FDzdC9xRY-9JS0lSurwBc6@mail.gmail.com>
	<AANLkTimYeL4KQozuTl4le9WUpObsjwp0YAx7eAYq6MBr@mail.gmail.com>
	<AANLkTikOgv6d0FlXu2-smnYPApeehjRq_j8UxEealqFC@mail.gmail.com>
	<AANLkTinynNqs6_zyTJcpi7yKiSvC5fBhbM2tVZcnoNUq@mail.gmail.com>
	<AANLkTinyGlwqq4xshLU5Ol74p0VfcUXBjBGKXlsB2pMy@mail.gmail.com>
	<AANLkTimIeTadyAhUuri2P630mpDwmBk4B90RpERLbaFE@mail.gmail.com>
	<AANLkTilXJHs8emXX4YNHbPq0SkuC4Z22NEh-T6mwUSHS@mail.gmail.com>
From: Weedy <weedy2887@gmail.com>
Date: Wed, 26 May 2010 17:47:39 -0400
Message-ID: <AANLkTim75PbxPyWRYld12V88ByF6Et3ULlGnZnvK80oY@mail.gmail.com>
Subject: Re: ath5k past 2.6.30 breaks monitor mode (and thus the aircrack
	suite)
To: Bob Copeland <me@bobcopeland.com>
Cc: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/5/26 Bob Copeland <me@bobcopeland.com>:
> 2010/5/25 Gábor Stefanik <netrolller.3d@gmail.com>:
>> On Tue, May 25, 2010 at 4:53 PM, Bob Copeland <me@bobcopeland.com> wrote:
>>> 2010/5/25 Weedy <weedy2887@gmail.com>:
>>>> 2010/5/24 Gábor Stefanik <netrolller.3d@gmail.com>:
>>>>> 2010/5/25 Weedy <weedy2887@gmail.com>:
>>>>>> 2010/5/23 Gábor Stefanik <netrolller.3d@gmail.com>:
>>>>>>> In the meantime, one thing to test: Add a printk of sc->opmode.
>>>>>>
>>>>>> May 24 22:04:20 tiny-h4x kernel: [41147.243149] sc->opmode: 02 (over9000 times)
>>>>>>
>>>>>> So i'm guessing I did it wrong (I don't know C).
>>>>>>        printk(KERN_NOTICE "sc->opmode: %02x\n", sc->opmode);
>>>>>>
>>>>>
>>>>> No, that is correct, and proves my theory (2 is NL80211_IFTYPE_STATION
>>>>> - it should be 6 for monitor mode).
>>>>>
>>>>> BTW, please use "Reply to all".
>>>>>
>>>> gmail got rid of the "Reply to all by default" option :<
>>>>
>>>> When you have a patch I will be waiting.
>>>
>>> Sorry, I missed this thread somehow.  Thanks for the detective
>>> work and apologies for my stupid goof.  Gábor, are you prepping
>>> a patch?  I can fix it if you like.
>>>
>>
>> If you can, please fix it - I know what the bug is, but have no solid
>> idea about a fix.
>
> Ok, it should be enough to look at the filter flags instead of
> the opmode -- I knew in the back of my mind that the monitor
> stuff was bogus (part of the reason I did the patch in the first
> place) but just got confused by what was already there I guess.
>
>

I await your patch with open arms.
