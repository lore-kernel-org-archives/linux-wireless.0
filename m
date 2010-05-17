Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:49044 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab0EQGjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 02:39:12 -0400
Received: by gxk9 with SMTP id 9so3023507gxk.8
        for <linux-wireless@vger.kernel.org>; Sun, 16 May 2010 23:39:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim1i3oB10rydr8ezyCjher1yctqKcVt9Ct1Bze0@mail.gmail.com>
References: <AANLkTimltZSc8dJPPBCibcGDaOPcQRU_5kSbenIAdi_6@mail.gmail.com>
	<AANLkTim1i3oB10rydr8ezyCjher1yctqKcVt9Ct1Bze0@mail.gmail.com>
From: Weedy <weedy2887@gmail.com>
Date: Mon, 17 May 2010 02:38:51 -0400
Message-ID: <AANLkTinYZ-_DkNZweDFfdf_DdDJGMNhgQwppDnVo_Duj@mail.gmail.com>
Subject: Re: ath5k past 2.6.30 breaks monitor mode (and thus the aircrack
	suite)
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/5/16 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Sun, May 16, 2010 at 10:41 PM, Weedy <weedy2887@gmail.com> wrote:
>> Running airodump on ubuntus 2.6.30 kernel works as expected. The
>> 2.6.32 kernel shipped in lucid never sees data packets.
>>
>> I have narrowed it down to channel hopping. modprobing the driver and
>> starting mon0 on a fixed channel works as expected, but allowing
>> airodump to channel hop breaks the interface until the driver is
>> reset.
>>
>> I wrote a script to download and build compat wireless starting from
>> 2009-01-01 (granted everything fails until half way through october),
>> but every version that is successfully installed also show the same
>> bug.
>>
>> Further instructions welcome.
>
> Try checking out linux-2.6, and doing a bisect between 2.6.30 and 2.6.32.

Do I have to check out the entire kernel? even with scripting my
netbook would take forever to do this.
