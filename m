Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:48909 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab0DLUGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 16:06:08 -0400
Received: by ewy20 with SMTP id 20so2250792ewy.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 13:06:05 -0700 (PDT)
Message-ID: <4BC37D2B.8020502@gmail.com>
Date: Mon, 12 Apr 2010 22:06:03 +0200
From: =?UTF-8?B?VG9ycXVpbCBNYWNkb25hbGQgU8O4cmVuc2Vu?=
	<torquil@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k compilation error
References: <4BC2EF3B.2060902@gmail.com> <n2k43e72e891004121221rac6e1a98k824bcf370974a00c@mail.gmail.com>
In-Reply-To: <n2k43e72e891004121221rac6e1a98k824bcf370974a00c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/04/10 21:21, Luis R. Rodriguez wrote:
> On Mon, Apr 12, 2010 at 3:00 AM, Torquil Macdonald Sørensen
>> I'm getting an error when compiling the ath9k driver in
>> compat-wireless-2010-04-11. The version 2010-04-04 compiles fine after
>> fixing a simple
>>
>> First I do:
>>
>> ./scripts/driver-select ath9k
>>
>> The I run "make", and after some time I get the following:
>>
>>   CC [M]  /home/tmac/src/compat-wireless-2010-04-11/net/mac80211/main.o
>> /home/tmac/src/compat-wireless-2010-04-11/net/mac80211/main.c: In function
>> ‘ieee80211_alloc_hw’:
>> /home/tmac/src/compat-wireless-2010-04-11/net/mac80211/main.c:394: error:
>> implicit declaration of function ‘__hw_addr_init’
>> make[5]: *** [/home/tmac/src/compat-wireless-2010-04-11/net/mac80211/main.o]
>> Error 1
>> make[4]: *** [/home/tmac/src/compat-wireless-2010-04-11/net/mac80211] Error
>> 2
>> make[3]: *** [_module_/home/tmac/src/compat-wireless-2010-04-11] Error 2
>> make[2]: *** [sub-make] Error 2
>>
>>
>> I want to try the newest driver because I have a lot of dropout problems
>> when using my "Atheros Communications Inc. AR9285 Wireless Network Adapter
>> (PCI-Express) (rev 01)"
>>
>> gcc (Debian 4.4.3-7) 4.4.3
>
> What kernel version are you on?
>

Hi Luis!

tmac@asus ~$ uname -a
Linux asus 2.6.32-3-amd64 #1 SMP Wed Feb 24 18:07:42 UTC 2010 x86_64 GNU/Linux

It is from the Debian package linux-image-2.6.32-3-amd64, with Debian version 
number 2.6.32-9. At the same time I have the corresponding kernel header 
packages installed:

linux-headers-2.6.32-3-common (Debian version 2.6.32-9)
linux-headers-2.6.32-3-amd64 (Debian version 2.6.32-9)

Torquil
