Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65176 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab0EYNa2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 09:30:28 -0400
Received: by gwaa20 with SMTP id a20so1979298gwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 May 2010 06:30:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikOgv6d0FlXu2-smnYPApeehjRq_j8UxEealqFC@mail.gmail.com>
References: <AANLkTimltZSc8dJPPBCibcGDaOPcQRU_5kSbenIAdi_6@mail.gmail.com>
	<AANLkTinYZ-_DkNZweDFfdf_DdDJGMNhgQwppDnVo_Duj@mail.gmail.com>
	<AANLkTimaLEQYH4Y7HO4Fv4zT8w8AsPkaAQtk9EauX4Bt@mail.gmail.com>
	<AANLkTikRt1fUgngBQxEoEFe1VDrYVFRAoMSR53et7gxf@mail.gmail.com>
	<AANLkTim-A_TWT-flrW88gJGan47Xhm7llyrQE3ehDKU6@mail.gmail.com>
	<AANLkTim4zLxIQH2r76WZRh9kNigVNAngcK1d9-Cu65Ag@mail.gmail.com>
	<AANLkTimH3p-dBA_6ee2a0iCnPDhtPZONzCEVkzMHrUWo@mail.gmail.com>
	<AANLkTim-4UNn8acYvF7AF2FDzdC9xRY-9JS0lSurwBc6@mail.gmail.com>
	<AANLkTimYeL4KQozuTl4le9WUpObsjwp0YAx7eAYq6MBr@mail.gmail.com>
	<AANLkTikOgv6d0FlXu2-smnYPApeehjRq_j8UxEealqFC@mail.gmail.com>
From: Weedy <weedy2887@gmail.com>
Date: Tue, 25 May 2010 09:30:03 -0400
Message-ID: <AANLkTinynNqs6_zyTJcpi7yKiSvC5fBhbM2tVZcnoNUq@mail.gmail.com>
Subject: Re: ath5k past 2.6.30 breaks monitor mode (and thus the aircrack
	suite)
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/5/24 Gábor Stefanik <netrolller.3d@gmail.com>:
> 2010/5/25 Weedy <weedy2887@gmail.com>:
>> 2010/5/23 Gábor Stefanik <netrolller.3d@gmail.com>:
>>> In the meantime, one thing to test: Add a printk of sc->opmode.
>>
>> May 24 22:04:20 tiny-h4x kernel: [41147.243149] sc->opmode: 02 (over9000 times)
>>
>> So i'm guessing I did it wrong (I don't know C).
>>        printk(KERN_NOTICE "sc->opmode: %02x\n", sc->opmode);
>>
>
> No, that is correct, and proves my theory (2 is NL80211_IFTYPE_STATION
> - it should be 6 for monitor mode).
>
> BTW, please use "Reply to all".
>
gmail got rid of the "Reply to all by default" option :<

When you have a patch I will be waiting.
