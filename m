Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58382 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab0EYOxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 10:53:48 -0400
Received: by gyg13 with SMTP id 13so2018192gyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 May 2010 07:53:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinynNqs6_zyTJcpi7yKiSvC5fBhbM2tVZcnoNUq@mail.gmail.com>
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
Date: Tue, 25 May 2010 10:53:47 -0400
Message-ID: <AANLkTinyGlwqq4xshLU5Ol74p0VfcUXBjBGKXlsB2pMy@mail.gmail.com>
Subject: Re: ath5k past 2.6.30 breaks monitor mode (and thus the aircrack
	suite)
From: Bob Copeland <me@bobcopeland.com>
To: Weedy <weedy2887@gmail.com>
Cc: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/5/25 Weedy <weedy2887@gmail.com>:
> 2010/5/24 Gábor Stefanik <netrolller.3d@gmail.com>:
>> 2010/5/25 Weedy <weedy2887@gmail.com>:
>>> 2010/5/23 Gábor Stefanik <netrolller.3d@gmail.com>:
>>>> In the meantime, one thing to test: Add a printk of sc->opmode.
>>>
>>> May 24 22:04:20 tiny-h4x kernel: [41147.243149] sc->opmode: 02 (over9000 times)
>>>
>>> So i'm guessing I did it wrong (I don't know C).
>>>        printk(KERN_NOTICE "sc->opmode: %02x\n", sc->opmode);
>>>
>>
>> No, that is correct, and proves my theory (2 is NL80211_IFTYPE_STATION
>> - it should be 6 for monitor mode).
>>
>> BTW, please use "Reply to all".
>>
> gmail got rid of the "Reply to all by default" option :<
>
> When you have a patch I will be waiting.

Sorry, I missed this thread somehow.  Thanks for the detective
work and apologies for my stupid goof.  Gábor, are you prepping
a patch?  I can fix it if you like.

-- 
Bob Copeland %% www.bobcopeland.com
