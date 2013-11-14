Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:36871 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab3KNUE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 15:04:27 -0500
Received: by mail-bk0-f44.google.com with SMTP id d7so1298789bkh.3
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 12:04:25 -0800 (PST)
Message-ID: <52852CC7.4080909@gmail.com> (sfid-20131114_210439_145764_098258E3)
Date: Thu, 14 Nov 2013 22:04:23 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Federico Tomassetti <f.tomassetti@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Iwlwifi crashing with microcode error - Intel 7260 N
References: <CAFux1qFNMwOKEOQ-46xev9LHPanV5NxPXW3UjKGY1od-+6KDCA@mail.gmail.com>	<528523EA.80600@gmail.com> <CAFux1qFFY6=6X0+zXr++gJK=zyU=HF24C2gFVtUishLG+4MZEg@mail.gmail.com>
In-Reply-To: <CAFux1qFFY6=6X0+zXr++gJK=zyU=HF24C2gFVtUishLG+4MZEg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/14/2013 09:27 PM, Federico Tomassetti wrote:
> No, I am just using it to connet to my wireless router and navigate from home,
> 

ok - please send the output of:
iw reg get
iw list

I also would like to see your syslog.
What is the channel your AP is working on?


> Federico
> 
> On Thu, Nov 14, 2013 at 8:26 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>
>>
>> On 11/14/2013 09:12 PM, Federico Tomassetti wrote:
>>> Hi,
>>> I tried with different kernel, right now I am using the wireless
>>> testing kernel and still I get this error.
>>>
>>> uname -a:
>>> Linux normandy 3.12.0-wl+ #1 SMP Wed Nov 13 19:42:50 CET 2013 x86_64
>>> Intel(R) Core(TM) i7-4700MQ CPU @ 2.40GHz GenuineIntel GNU/Linux
>>>
>>> How can I help you working on this bug?
>>>
>>
>> You are using it as an AP, right?
> 
> 
> 
