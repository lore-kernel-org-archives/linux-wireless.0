Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:46058 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092AbZJSRaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 13:30:16 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1585768fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2009 10:30:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <279b980f0910191011p50064547r6d77a5ac32e22f93@mail.gmail.com>
References: <1255861930.5093.7.camel@chriss-imac> <69e28c910910180602qe4cdb1fy5c2ec3f6dae0c146@mail.gmail.com>
	<279b980f0910191011p50064547r6d77a5ac32e22f93@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 19 Oct 2009 19:29:59 +0200
Message-ID: <69e28c910910191029v244b0613g664204f0d453e6a4@mail.gmail.com>
Subject: Re: Support for Broadcom's BCM4328 chip
To: Russell Knighton <russell@knighton.me.uk>
Cc: Chriss Kalogeropoulos <iz.iznogood@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/10/19 Russell Knighton <russell@knighton.me.uk>
>
> Great news that this is now truly under-way - but, at the risk of sounding cheeky, is there an estimated merge date on this (or any progress information you can share)? I have a broadcom BCM4322 and would like to get involved in any possible testing, or at the very least be able to check the progress on this.
>
> Thanks for all your hard work - your skill and efforts are highly appreciated by us end users!
>
> Russell
>

Only reverse-engineering is happening at this point - actual
development can only start once reverse-engineering is done. (And even
then, we will need to find someone to actually write the code for
N-PHY, as I'm not sure that I will have enough free time to do it
myself, and Michael seems to have practically abandoned the project.)

> 2009/10/18 Gábor Stefanik <netrolller.3d@gmail.com>
>>
>> On Sun, Oct 18, 2009 at 12:32 PM, Chriss Kalogeropoulos
>> <iz.iznogood@gmail.com> wrote:
>> > Hello,
>> >
>> > i have an i-mac using Broadcom's BCM4328 chip.
>> >
>> > lspci gives:
>> >
>> > 03:00.0 Network controller [0280]: Broadcom Corporation BCM4328
>> > 802.11a/b/g/n [14e4:4328] (rev 01)
>> >
>> > This must have been answered before but i thought to ask in case
>> > something has changed. Any hope on getting support on that chip with an
>> > open source driver ?
>> >
>> > Please cc me since i am not a subscriber on the list.
>> >
>> > Thanks in advance
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>> This is an N-PHY card. Reverse-engineering of N-PHY cards is still in
>> progress (though it is finally really "in progress", and not stalled
>> anymore), and it needs to be finished (at least the G part) before we
>> can work on implementing it.
>>
>> --
>> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



--
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
