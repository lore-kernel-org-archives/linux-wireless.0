Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46252 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755086Ab2D3Dfe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2012 23:35:34 -0400
Received: by lahj13 with SMTP id j13so1602706lah.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2012 20:35:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F9DFF0A.7080604@lwfinger.net>
References: <CAKVccoU7CnhVVQ82U23Yuww6VrTMU4FsjWcWVbk16LNKyQfvOQ@mail.gmail.com>
 <A872091605A443F48DE1814CF6FAFE25@realtek.com.tw> <CAKVccoUfER_m48BtyMjo3pix2_BmqBZ8kxij_RxDhOLEN5Q-9A@mail.gmail.com>
 <4F9AF76A.4040607@lwfinger.net> <CAKVccoUbcvO-X5w2pOuOyP=DhK+64opsJm5muznjsOWu==MUcQ@mail.gmail.com>
 <4F9B63CF.4010005@lwfinger.net> <CAKVccoW8GCE=QSC9db6EnoEOsnBkKNoEvqzRrn8orbkf=U66Dg@mail.gmail.com>
 <4F9BFA14.3070008@lwfinger.net> <CAKVccoWRdcB87DB22=hy9wvEuR7exB7LV8zEGwq1+ug6YK2Zig@mail.gmail.com>
 <CAKVccoX-rjdapPE9N4vK6GYGrLVBQmD5yzz79ko4Uv=Uj=K6gA@mail.gmail.com>
 <4F9DD22F.8010305@lwfinger.net> <CAKVccoWbiKMPSH-jHHS+L+B-C1+ZZntxdP45ZxuxaN3h3C1iGA@mail.gmail.com>
 <4F9DE46E.6030103@lwfinger.net> <CAKVccoVU6uMNF0ShZO2jpsJzcf2MhaYzhELimS051TX2hVvyXQ@mail.gmail.com>
 <CAKVccoXJxLVm=3v2QnvKq1b3N76eXoNR45GfJ0TzRYx-BuM-fA@mail.gmail.com> <4F9DFF0A.7080604@lwfinger.net>
From: simple w8 <simplew8@gmail.com>
Date: Mon, 30 Apr 2012 04:35:12 +0100
Message-ID: <CAKVccoWt-rhfWBynb2kTXD6CU52WtXfqYNmmOCmUaTqCfjdWzg@mail.gmail.com> (sfid-20120430_053544_587023_0900EBD0)
Subject: Re: rtl8192ce makes keyboard repeat and mouse freeze
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/4/30 Larry Finger <Larry.Finger@lwfinger.net>:
> On 04/29/2012 08:11 PM, simple w8 wrote:
>>
>> 2012/4/30 simple w8<simplew8@gmail.com>:
>>>
>>> 2012/4/30 Larry Finger<Larry.Finger@lwfinger.net>:
>>>>
>>>> On 04/29/2012 07:51 PM, simple w8 wrote:
>>>>>
>>>>>
>>>>> 2012/4/30 Larry Finger<Larry.Finger@lwfinger.net>:
>>>>
>>>>
>>>>
>>>>>> Get
>>>>>>
>>>>>>
>>>>>> http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2012-04-26.tar.bz2.
>>>>>> That is the "bleeding-edge" version. As I said in the previous
>>>>>> message,
>>>>>> it
>>>>>> will build on your kernel!
>>>>>
>>>>>
>>>>>
>>>>> I didnt remove any mail address i simply forgot to hit the reply all
>>>>> button.
>>>>
>>>>
>>>>
>>>> That IS removing mail addresses.
>>>>
>>>>
>>>>> Previously i tried to build the subdirectory rtlwifi but that wasnt
>>>>> possible, so build the entry tree compat-wireless and installed it,
>>>>> but the problem about having repeated chars when typing and the mouse
>>>>> freeze continues happening.
>>>>>
>>>>> Now a different problem, i noticed that after kernel-3.3.1 it started
>>>>> appearing less wifi networks, where i used to detect about 10 wifi
>>>>> networks, with kernel>    3.3.1 it only detected about 2 or 3 wifi
>>>>> networks, i reported that to the distro and they said was a problem
>>>>> from upstream since they didnt had changed nothing regarding wifi, and
>>>>> after i installed compat-wireless that was solved. Im running
>>>>> kernel-3.3.4 with compat-wireless and it detects again about 10 wifi
>>>>> networks.
>>>>>
>>>>> Should i report this upstream so it can be fixed still in the
>>>>> kkkkkernel 3.3.4 serie or you ccccccan do it?
>>>>
>>>>
>>>>
>>>> Whatever patch that fixed that problem will be backported to 3.3.X if it
>>>> can
>>>> be. Not everything qualifies.
>>>>
>>>>
>>>>> By the way see how the characters "k" and "c" got repeated when i was
>>>>> typing last paragraph.
>>>>
>>>>
>>>>
>>>> I see them, but they do not happen on my machine, thus I have no idea of
>>>> the
>>>> cause. So far, you can only say that they don't happen when rtl8192ce is
>>>> not
>>>> loaded; however, you have no network then either. The problem could be
>>>> anywhere in the network stack.
>>>>
>>>> You said earlier that you tried the Ubuntu Live system. Would it be
>>>> possible
>>>> to download and try the openSUSE 12.1 Live CD as well? As you have used
>>>> Ubunbtu, you should try the Gnome version.
>>>>
>>>> Larry
>>>
>>>
>>> These are the distros that i tried so far and all presented the same
>>> problem i have described:
>>> - Mandriva
>>> - Mageia
>>> - Ubuntu
>>> - Kubuntu
>>> - Caixa Magica
>>
>>
>> What wifi you have?
>> What distro you run?
>> Do you run NetworManager?
>
>
> You forgot the "Reply All" again!
>
> I run openSUSE 12.1 KDE, and I use NetworkManager.
>
> I have many wifi devices, including both RTL8188CE and RTL8192CE. At the
> moment, I am running an RTL8188CE, which has been up for nearly 100 hours
> without dropping the connection, and with no problems with the keyboard. My
> kernel is from wireless-testing, which means that my wireless stuff is
> exactly what you got with compat-wireless.

So you also use wpa_supplicant, so what happens is that when i turn
off wpa_supplicant the problem goes away but i also loose wifi
internet, and of course if i unload the rtl8192ce module.

This problem has been existing for quite some time, also in another 2
machines that also have realtek wifi cards, so this problem isnt just
from this specific card, but i really cant tell if this is really some
caused by the realtek drivers or wpa_supplicant or any other thing...

I have mailed hostap mailing list to see what were the chances someone
knows about a similiar problem but the no one seams to know...
