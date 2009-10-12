Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:43256 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932949AbZJLSSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 14:18:51 -0400
Received: by fxm27 with SMTP id 27so9485524fxm.17
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2009 11:18:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1df1788c0910121112v13b5f16fy5b3b79dcd86e37d5@mail.gmail.com>
References: <1df1788c0910110455q570ca89fy6edbda3235a7a35e@mail.gmail.com>
	<1df1788c0910110513j6847bf97q71059fec4ae9722b@mail.gmail.com>
	<1df1788c0910110518l1d120983id2bf997d2446b4a7@mail.gmail.com>
	<20091012134325.GC27575@tuxdriver.com> <1df1788c0910121112v13b5f16fy5b3b79dcd86e37d5@mail.gmail.com>
From: =?UTF-8?Q?Br=C3=A1ulio_B_O_Bhavamitra?= <brauliobo@gmail.com>
Date: Mon, 12 Oct 2009 15:17:54 -0300
Message-ID: <1df1788c0910121117g5ad66013g95e2231fd983bb23@mail.gmail.com>
Subject: Re: RaLink 148f:3070 not working since upgrade from 2.6.30 to 2.6.31
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/10/12 Bráulio B O Bhavamitra <brauliobo@gmail.com>
>
> 2009/10/12 John W. Linville <linville@tuxdriver.com>
>>
>> On Sun, Oct 11, 2009 at 09:18:24AM -0300, Bráulio B O Bhavamitra wrote:
>> > Also in Ubuntu Karmic Beta (where the firmware is present) it doesn't
>> > work (radio not working, can't find any access point)
>> >
>> > 2009/10/11 Bráulio B O Bhavamitra <brauliobo@gmail.com>:
>> > > Since the upgrade from kernel 2.6.30 to 2.6.31 on archlinux the usb
>> > > wireless from Ralink doesn't work anymore.
>> > > Please ask for more info if necessary.
>>
>> This commit is post-2.6.30 (and pre-2.6.31):
>>
>> commit d53d9e67b55f6a9fc3f836c5c392eb41ce5676f4
>> Author: Ivo van Doorn <IvDoorn@gmail.com>
>> Date:   Sun Apr 26 15:47:48 2009 +0200
>>
>>    rt2x00: Implement support for rt2800usb
>>
>>    Add support for the rt2800usb chipset.
>>
>>    Current problems:
>>     * Cannot scan 11n AP's
>>     * No TX during first minute after association
>>     * Broken Hardware encryption
>>
>>    Includes various patches from Mattias, Felix, Xose and Axel.
>>
>>    Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
>>    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>>    Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>>    Signed-off-by: Axel Kollhofer <rain_maker@root-forum.org>
>>    Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
>>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>
>> That is the first time 148f:3070 is supported by the rt2x00 drivers.
>> I have no idea what you were using up to 2.6.30...
>
> Ow, this is really strange.
> I was using the ArchLinux's 2.6.30.6 kernel which is an almost vanilla kernel.
> Very strange, I remember seeing it loading the <something>2870sta module and worked perfectly.
>>
>> John
>> --
>> John W. Linville                Someday the world will need a hero, and you
>> linville@tuxdriver.com                  might be all we have.  Be ready.
>
