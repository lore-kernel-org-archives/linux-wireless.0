Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:48859 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab2DFGFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 02:05:19 -0400
Received: by qadc11 with SMTP id c11so201275qad.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Apr 2012 23:05:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFED-jnO235WRNT34DN6OAUKPgeT6t0eWdHK+9_gz7dTvdMTgQ@mail.gmail.com>
References: <CAFED-jmkmF=9egOvvRK49=2HYMg_jiAUdW=5XQ2SyFwYXDb1OQ@mail.gmail.com>
	<1333630881.3494.15.camel@jlt3.sipsolutions.net>
	<CAFED-j=jReYjht2TazFmYnqzJHkS-=My-_4MDRmbtBfvGz_Txw@mail.gmail.com>
	<CAFED-jnO235WRNT34DN6OAUKPgeT6t0eWdHK+9_gz7dTvdMTgQ@mail.gmail.com>
Date: Fri, 6 Apr 2012 08:05:19 +0200
Message-ID: <CAFED-jkaA8S6a9qSxF0SgwoexEAQvFUqF1WmVLBx-__GhRaS0g@mail.gmail.com> (sfid-20120406_080523_294684_3C6C5CEE)
Subject: Re: compat-wireless-2012-04-04 - rmmod mac80211 and PC freeze
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 6 kwietnia 2012 07:16 u¿ytkownik Janusz Dziedzic
<janusz.dziedzic@gmail.com> napisa³:
> W dniu 6 kwietnia 2012 07:00 u¿ytkownik Janusz Dziedzic
> <janusz.dziedzic@gmail.com> napisa³:
>> W dniu 5 kwietnia 2012 15:01 u¿ytkownik Johannes Berg
>> <johannes@sipsolutions.net> napisa³:
>>> On Thu, 2012-04-05 at 14:35 +0200, Janusz Dziedzic wrote:
>>>> Hello,
>>>>
>>>> I am using: compat-wireless-2012-04-04
>>>>
>>>> I am doing such test:
>>>> - insmod compat.ko
>>>> - insmod cfg80211.ko
>>>> - insmod mac80211.ko
>>>>
>>>> After that:
>>>> - rmmod mac80211
>>>>
>>>> And have PC freeze.
>>>> Linux uw000950 2.6.35-32-generic #67~lucid1-Ubuntu SMP Tue Mar 6
>>>> 17:48:20 UTC 2012 x86_64 GNU/Linux
>>>
>>> Works for me, but on 3.1.0.
>>>
>>>> Any idea what could be wrong, how to debug in case of such freeze?
>>>
>>> Not really. You could try the same thing from a console, rather than an
>>> X terminal window (that I'm guessing you're using since you saw no
>>> further info) and you may see some more details?
>>>
>>> johannes
>>>
>>
>> Seems when run from console I see:
>> Kernel panic - not syncing: Fatal exception in interrupt
>> BUG: scheduling while atomic: rmmod/15474/0x10008803
>>
>> Next a lot of information connected with dump.
>>
>>
>
> After second try:
> BUG: unable to handle kernel paging request at ffffffff98d60d20
> IP: update_curr+0x134/0x1e0
> Thread overran stack, or stack corrupted
> Process rmmod
>

Issue not reproducible with compat-wireless-2012-03-18.
Seems introduced in compat-wireless-2012-04-03.

BR
Janusz
