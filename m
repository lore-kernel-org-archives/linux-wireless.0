Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65527 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab0EQLVu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 07:21:50 -0400
Received: by fxm6 with SMTP id 6so3689509fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 May 2010 04:21:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinYZ-_DkNZweDFfdf_DdDJGMNhgQwppDnVo_Duj@mail.gmail.com>
References: <AANLkTimltZSc8dJPPBCibcGDaOPcQRU_5kSbenIAdi_6@mail.gmail.com>
	<AANLkTim1i3oB10rydr8ezyCjher1yctqKcVt9Ct1Bze0@mail.gmail.com>
	<AANLkTinYZ-_DkNZweDFfdf_DdDJGMNhgQwppDnVo_Duj@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 17 May 2010 13:21:29 +0200
Message-ID: <AANLkTimaLEQYH4Y7HO4Fv4zT8w8AsPkaAQtk9EauX4Bt@mail.gmail.com>
Subject: Re: ath5k past 2.6.30 breaks monitor mode (and thus the aircrack
	suite)
To: Weedy <weedy2887@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/5/17 Weedy <weedy2887@gmail.com>:
> 2010/5/16 Gábor Stefanik <netrolller.3d@gmail.com>:
>> On Sun, May 16, 2010 at 10:41 PM, Weedy <weedy2887@gmail.com> wrote:
>>> Running airodump on ubuntus 2.6.30 kernel works as expected. The
>>> 2.6.32 kernel shipped in lucid never sees data packets.
>>>
>>> I have narrowed it down to channel hopping. modprobing the driver and
>>> starting mon0 on a fixed channel works as expected, but allowing
>>> airodump to channel hop breaks the interface until the driver is
>>> reset.
>>>
>>> I wrote a script to download and build compat wireless starting from
>>> 2009-01-01 (granted everything fails until half way through october),
>>> but every version that is successfully installed also show the same
>>> bug.
>>>
>>> Further instructions welcome.
>>
>> Try checking out linux-2.6, and doing a bisect between 2.6.30 and 2.6.32.
>
> Do I have to check out the entire kernel? even with scripting my
> netbook would take forever to do this.
>

Yes, you need to check out the entire repo - but with git, you do not
need to re-download the whole tree everytime you check out a new
revision; it is a distributed system. git is not CVS. :-)

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
