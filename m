Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33376 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754904Ab2D3AwQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2012 20:52:16 -0400
Received: by lahj13 with SMTP id j13so1557521lah.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2012 17:52:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F9DD22F.8010305@lwfinger.net>
References: <CAKVccoU7CnhVVQ82U23Yuww6VrTMU4FsjWcWVbk16LNKyQfvOQ@mail.gmail.com>
 <A872091605A443F48DE1814CF6FAFE25@realtek.com.tw> <CAKVccoUfER_m48BtyMjo3pix2_BmqBZ8kxij_RxDhOLEN5Q-9A@mail.gmail.com>
 <4F9AF76A.4040607@lwfinger.net> <CAKVccoUbcvO-X5w2pOuOyP=DhK+64opsJm5muznjsOWu==MUcQ@mail.gmail.com>
 <4F9B63CF.4010005@lwfinger.net> <CAKVccoW8GCE=QSC9db6EnoEOsnBkKNoEvqzRrn8orbkf=U66Dg@mail.gmail.com>
 <4F9BFA14.3070008@lwfinger.net> <CAKVccoWRdcB87DB22=hy9wvEuR7exB7LV8zEGwq1+ug6YK2Zig@mail.gmail.com>
 <CAKVccoX-rjdapPE9N4vK6GYGrLVBQmD5yzz79ko4Uv=Uj=K6gA@mail.gmail.com> <4F9DD22F.8010305@lwfinger.net>
From: simple w8 <simplew8@gmail.com>
Date: Mon, 30 Apr 2012 01:51:54 +0100
Message-ID: <CAKVccoWbiKMPSH-jHHS+L+B-C1+ZZntxdP45ZxuxaN3h3C1iGA@mail.gmail.com> (sfid-20120430_025256_140605_42EDE8DD)
Subject: Re: rtl8192ce makes keyboard repeat and mouse freeze
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/4/30 Larry Finger <Larry.Finger@lwfinger.net>:
> On 04/29/2012 06:20 PM, simple w8 wrote:
>>
>> 2012/4/29 simple w8<simplew8@gmail.com>:
>>>
>>> 2012/4/28 Larry Finger<Larry.Finger@lwfinger.net>:
>>>>
>>>> On 04/27/2012 11:30 PM, simple w8 wrote:
>>>>>
>>>>>
>>>>> 2012/4/28 Larry Finger<Larry.Finger@lwfinger.net>:
>>>>>>
>>>>>>
>>>>>> On 04/27/2012 04:36 PM, simple w8 wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> What details more i could provide, could you clarify please?
>>>>>>>
>>>>>>
>>>>>> What distro do you use? How do you control the wifi? Do you use
>>>>>> NetworkManager, or what? If you use wicd, then that is likely the
>>>>>> problem!
>>>>>> These are the kinds of details that should have been in your first
>>>>>> message.
>>>>>>
>>>>>> You need to get the compat-wireless source from
>>>>>> http://wireless.kernel.org/en/users/Download, and build it on your
>>>>>> system.
>>>>>
>>>>>
>>>>>
>>>>> In previous message i clarified that the distro uses NetworkManager
>>>>> NetworkManager (and networkmanager calls wpa_supplicant through dbus).
>>>>> The distro i use is Mageia, but when i run Ubuntu live cd i found the
>>>>> same exact problem.
>>>>>
>>>>> For what i see compat-wireless file arepart of the kernel, and the
>>>>> distro already provides the latest kernel available thats version
>>>>> 3.3.3.
>>>>
>>>>
>>>>
>>>> I do not like your tone!! If you want help, please watch what you say.
>>>
>>>
>>> Hu?
>>> I dont understand why your saying this, seams your in a bad mood but
>>> thats certainly not my fault...
>>>
>>>> For your information, the latest compat-wireless has the wireless code
>>>> that
>>>> will be in kernel 3.5. That is the reason I want you to try it.
>>>
>>>
>>> Anyway in the website you pointed i see this to download:
>>>
>>> http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2
>>> but for what i read there this isnt for kernel-2.6 series?
>>
>>
>> Anyway i have found this:
>>
>> http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2
>>
>> but isnt possible to build, see the output (build against kernel-3.3.4):
>>
>>
>> DKMS make.log for rtlwifi-1-1.mde2 for kernel 3.3.4-desktop-1.mga2
>> (x86_64)
>> Seg Abr 30 00:16:54 WEST 2012
>> make: Entrando no diretório `/usr/src/linux-3.3.4-desktop-1.mga2'
>>   LD      /var/lib/dkms/rtlwifi/1-1.mde2/build/built-in.o
>>   CC [M]  /var/lib/dkms/rtlwifi/1-1.mde2/build/base.o
>> In file included from /var/lib/dkms/rtlwifi/1-1.mde2/build/wifi.h:36:0,
>>                  from /var/lib/dkms/rtlwifi/1-1.mde2/build/base.c:30:
>> include/linux/printk.h:47:2: error: unknown type name ‘va_list’
>> include/linux/printk.h:91:8: warning: type defaults to ‘int’ in
>> declaration of ‘asmlinkage’ [-Wimplicit-int]
>> include/linux/printk.h:92:1: warning: ‘format’ attribute only applies
>> to function types [-Wattributes]
>> include/linux/printk.h:92:1: error: expected ‘,’ or ‘;’ before ‘void’
>> include/linux/printk.h:98:1: warning: data definition has no type or
>> storage class [enabled by default]
>> include/linux/printk.h:98:1: warning: type defaults to ‘int’ in
>> declaration of ‘asmlinkage’ [-Wimplicit-int]
>> include/linux/printk.h:99:1: warning: ‘format’ attribute only applies
>> to function types [-Wattributes]
>> include/linux/printk.h:99:1: error: expected ‘,’ or ‘;’ before ‘int’
>> include/linux/printk.h:100:1: warning: data definition has no type or
>> storage class [enabled by default]
>> include/linux/printk.h:100:1: warning: type defaults to ‘int’ in
>> declaration of ‘asmlinkage’ [-Wimplicit-int]
>> include/linux/printk.h:101:1: warning: ‘format’ attribute only applies
>> to function types [-Wattributes]
>> include/linux/printk.h:101:1: warning: ‘__cold__’ attribute ignored
>> [-Wattributes]
>> include/linux/printk.h:101:1: error: expected ‘,’ or ‘;’ before ‘int’
>> In file included from include/linux/etherdevice.h:28:0,
>>                  from /var/lib/dkms/rtlwifi/1-1.mde2/build/wifi.h:39,
>>                  from /var/lib/dkms/rtlwifi/1-1.mde2/build/base.c:30:
>> include/linux/netdevice.h: In function ‘netif_tx_stop_queue’:
>> include/linux/netdevice.h:1842:3: error: implicit declaration of
>> function ‘printk’ [-Werror=implicit-function-declaration]
>> cc1: some warnings being treated as errors
>
>
> Get
> http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2012-04-26.tar.bz2.
> That is the "bleeding-edge" version. As I said in the previous message, it
> will build on your kernel!

I didnt remove any mail address i simply forgot to hit the reply all button.

Previously i tried to build the subdirectory rtlwifi but that wasnt
possible, so build the entry tree compat-wireless and installed it,
but the problem about having repeated chars when typing and the mouse
freeze continues happening.

Now a different problem, i noticed that after kernel-3.3.1 it started
appearing less wifi networks, where i used to detect about 10 wifi
networks, with kernel > 3.3.1 it only detected about 2 or 3 wifi
networks, i reported that to the distro and they said was a problem
from upstream since they didnt had changed nothing regarding wifi, and
after i installed compat-wireless that was solved. Im running
kernel-3.3.4 with compat-wireless and it detects again about 10 wifi
networks.

Should i report this upstream so it can be fixed still in the
kkkkkernel 3.3.4 serie or you ccccccan do it?

By the way see how the characters "k" and "c" got repeated when i was
typing last paragraph.
