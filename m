Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51645 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab2D3CzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2012 22:55:10 -0400
Received: by iadi9 with SMTP id i9so3557013iad.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2012 19:55:09 -0700 (PDT)
Message-ID: <4F9DFF0A.7080604@lwfinger.net> (sfid-20120430_045548_045027_E9E59D50)
Date: Sun, 29 Apr 2012 21:55:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: simple w8 <simplew8@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192ce makes keyboard repeat and mouse freeze
References: <CAKVccoU7CnhVVQ82U23Yuww6VrTMU4FsjWcWVbk16LNKyQfvOQ@mail.gmail.com> <A872091605A443F48DE1814CF6FAFE25@realtek.com.tw> <CAKVccoUfER_m48BtyMjo3pix2_BmqBZ8kxij_RxDhOLEN5Q-9A@mail.gmail.com> <4F9AF76A.4040607@lwfinger.net> <CAKVccoUbcvO-X5w2pOuOyP=DhK+64opsJm5muznjsOWu==MUcQ@mail.gmail.com> <4F9B63CF.4010005@lwfinger.net> <CAKVccoW8GCE=QSC9db6EnoEOsnBkKNoEvqzRrn8orbkf=U66Dg@mail.gmail.com> <4F9BFA14.3070008@lwfinger.net> <CAKVccoWRdcB87DB22=hy9wvEuR7exB7LV8zEGwq1+ug6YK2Zig@mail.gmail.com> <CAKVccoX-rjdapPE9N4vK6GYGrLVBQmD5yzz79ko4Uv=Uj=K6gA@mail.gmail.com> <4F9DD22F.8010305@lwfinger.net> <CAKVccoWbiKMPSH-jHHS+L+B-C1+ZZntxdP45ZxuxaN3h3C1iGA@mail.gmail.com> <4F9DE46E.6030103@lwfinger.net> <CAKVccoVU6uMNF0ShZO2jpsJzcf2MhaYzhELimS051TX2hVvyXQ@mail.gmail.com> <CAKVccoXJxLVm=3v2QnvKq1b3N76eXoNR45GfJ0TzRYx-BuM-fA@mail.gmail.com>
In-Reply-To: <CAKVccoXJxLVm=3v2QnvKq1b3N76eXoNR45GfJ0TzRYx-BuM-fA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/29/2012 08:11 PM, simple w8 wrote:
> 2012/4/30 simple w8<simplew8@gmail.com>:
>> 2012/4/30 Larry Finger<Larry.Finger@lwfinger.net>:
>>> On 04/29/2012 07:51 PM, simple w8 wrote:
>>>>
>>>> 2012/4/30 Larry Finger<Larry.Finger@lwfinger.net>:
>>>
>>>
>>>>> Get
>>>>>
>>>>> http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2012-04-26.tar.bz2.
>>>>> That is the "bleeding-edge" version. As I said in the previous message,
>>>>> it
>>>>> will build on your kernel!
>>>>
>>>>
>>>> I didnt remove any mail address i simply forgot to hit the reply all
>>>> button.
>>>
>>>
>>> That IS removing mail addresses.
>>>
>>>
>>>> Previously i tried to build the subdirectory rtlwifi but that wasnt
>>>> possible, so build the entry tree compat-wireless and installed it,
>>>> but the problem about having repeated chars when typing and the mouse
>>>> freeze continues happening.
>>>>
>>>> Now a different problem, i noticed that after kernel-3.3.1 it started
>>>> appearing less wifi networks, where i used to detect about 10 wifi
>>>> networks, with kernel>    3.3.1 it only detected about 2 or 3 wifi
>>>> networks, i reported that to the distro and they said was a problem
>>>> from upstream since they didnt had changed nothing regarding wifi, and
>>>> after i installed compat-wireless that was solved. Im running
>>>> kernel-3.3.4 with compat-wireless and it detects again about 10 wifi
>>>> networks.
>>>>
>>>> Should i report this upstream so it can be fixed still in the
>>>> kkkkkernel 3.3.4 serie or you ccccccan do it?
>>>
>>>
>>> Whatever patch that fixed that problem will be backported to 3.3.X if it can
>>> be. Not everything qualifies.
>>>
>>>
>>>> By the way see how the characters "k" and "c" got repeated when i was
>>>> typing last paragraph.
>>>
>>>
>>> I see them, but they do not happen on my machine, thus I have no idea of the
>>> cause. So far, you can only say that they don't happen when rtl8192ce is not
>>> loaded; however, you have no network then either. The problem could be
>>> anywhere in the network stack.
>>>
>>> You said earlier that you tried the Ubuntu Live system. Would it be possible
>>> to download and try the openSUSE 12.1 Live CD as well? As you have used
>>> Ubunbtu, you should try the Gnome version.
>>>
>>> Larry
>>
>> These are the distros that i tried so far and all presented the same
>> problem i have described:
>> - Mandriva
>> - Mageia
>> - Ubuntu
>> - Kubuntu
>> - Caixa Magica
>
> What wifi you have?
> What distro you run?
> Do you run NetworManager?

You forgot the "Reply All" again!

I run openSUSE 12.1 KDE, and I use NetworkManager.

I have many wifi devices, including both RTL8188CE and RTL8192CE. At the moment, 
I am running an RTL8188CE, which has been up for nearly 100 hours without 
dropping the connection, and with no problems with the keyboard. My kernel is 
from wireless-testing, which means that my wireless stuff is exactly what you 
got with compat-wireless.

Larry
