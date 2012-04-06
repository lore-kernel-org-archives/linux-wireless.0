Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:65487 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2DFFAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 01:00:32 -0400
Received: by qadc11 with SMTP id c11so186366qad.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Apr 2012 22:00:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333630881.3494.15.camel@jlt3.sipsolutions.net>
References: <CAFED-jmkmF=9egOvvRK49=2HYMg_jiAUdW=5XQ2SyFwYXDb1OQ@mail.gmail.com>
	<1333630881.3494.15.camel@jlt3.sipsolutions.net>
Date: Fri, 6 Apr 2012 07:00:31 +0200
Message-ID: <CAFED-j=jReYjht2TazFmYnqzJHkS-=My-_4MDRmbtBfvGz_Txw@mail.gmail.com> (sfid-20120406_070103_460631_F7BB6E4E)
Subject: Re: compat-wireless-2012-04-04 - rmmod mac80211 and PC freeze
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 5 kwietnia 2012 15:01 u¿ytkownik Johannes Berg
<johannes@sipsolutions.net> napisa³:
> On Thu, 2012-04-05 at 14:35 +0200, Janusz Dziedzic wrote:
>> Hello,
>>
>> I am using: compat-wireless-2012-04-04
>>
>> I am doing such test:
>> - insmod compat.ko
>> - insmod cfg80211.ko
>> - insmod mac80211.ko
>>
>> After that:
>> - rmmod mac80211
>>
>> And have PC freeze.
>> Linux uw000950 2.6.35-32-generic #67~lucid1-Ubuntu SMP Tue Mar 6
>> 17:48:20 UTC 2012 x86_64 GNU/Linux
>
> Works for me, but on 3.1.0.
>
>> Any idea what could be wrong, how to debug in case of such freeze?
>
> Not really. You could try the same thing from a console, rather than an
> X terminal window (that I'm guessing you're using since you saw no
> further info) and you may see some more details?
>
> johannes
>

Seems when run from console I see:
Kernel panic - not syncing: Fatal exception in interrupt
BUG: scheduling while atomic: rmmod/15474/0x10008803

Next a lot of information connected with dump.


BR
Janusz
