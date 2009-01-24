Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:24553 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZAXR4J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 12:56:09 -0500
Received: by fk-out-0910.google.com with SMTP id f33so1792304fkf.5
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2009 09:56:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <e27b78a40901240804m1acd3a83o7bf6d01f81ec3397@mail.gmail.com>
References: <e27b78a40901230803t8eafb3cx6d70ceaec68daf09@mail.gmail.com>
	 <45e8e6c40901231106t481c823ag3bbac67d8205ef7a@mail.gmail.com>
	 <e27b78a40901240804m1acd3a83o7bf6d01f81ec3397@mail.gmail.com>
Date: Sat, 24 Jan 2009 09:56:06 -0800
Message-ID: <45e8e6c40901240956g68a5364tdbacc1e49410c9cc@mail.gmail.com> (sfid-20090124_185615_009597_E3829BBB)
Subject: Re: Crashing on ping?
From: Andrey Yurovsky <andrey@cozybit.com>
To: Keir <keirlawson@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can you post logs of the crash (dmesg output)?  You may need to
connect a serial console to the PC in question to get them if the
machine is really hard-locking, otherwise see if you can capture the
output of dmesg

On Sat, Jan 24, 2009 at 8:04 AM, Keir <keirlawson@gmail.com> wrote:
> Tried that commit, still no luck :( It consistently freezes up on
> ping, though sometimes it's the machine doing the pining, and other
> times it's the machine being pinged.  Wondering what I can do to help
> debug this?
>
> Keir
>
> 2009/1/23 Andrey Yurovsky <andrey@cozybit.com>:
>> Hi Keir.  Incidentally, we're using ath5k mesh right now at commit
>> 93bd2ac7301b0879821e584991f82de372d62bf6 (that's just after the
>> 2.6.29-rc1 tag but before -rc2) an things work fine.  I haven't had a
>> chance to try head of wireless-testing this week.
>>
>>  -Andrey
>>
>> On Fri, Jan 23, 2009 at 8:03 AM, Keir <keirlawson@gmail.com> wrote:
>>> I just pulled the latest wireless-testing kernel, however, much like
>>> the previous wireless-testing kernel I was working on, when attempting
>>> to ping one node from another on a mesh, using ath5k, the node
>>> attempting to ping completely freezes after about 7 pings are
>>> (succesfully) sent.  Anyone have any idea what is going wrong here?
>>>
>>> Cheers
>>>
>>> Keir
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>
