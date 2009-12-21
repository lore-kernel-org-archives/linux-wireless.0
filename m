Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:36578 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZLUPFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 10:05:00 -0500
Received: by fxm7 with SMTP id 7so4958882fxm.29
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 07:04:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BLU113-W10113EE534A08128E43979BE820@phx.gbl>
References: <BLU113-W7635FBD7855C5257B07E4BE820@phx.gbl> <69e28c910912210614v31edf6cej9abeddb17ab130d@mail.gmail.com>
	<BLU113-W10113EE534A08128E43979BE820@phx.gbl>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 21 Dec 2009 16:04:38 +0100
Message-ID: <69e28c910912210704m316c285et6e03baaafa85567c@mail.gmail.com>
Subject: Re: I need a card that works reasonably easily with Debain- reccs?
To: Mike Marchywka <marchywka@hotmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 21, 2009 at 3:51 PM, Mike Marchywka <marchywka@hotmail.com> wrote:
>
>
>
> Thanks.
> As near as I can tell from the driver files it should be a netgear WG311v3
> 802.11g. May be a card mismatch but I'd have to pull machine apart to check.

The WG311v3 is a Marvell chipset, with no native driver.

>
> Are there known issues with ndiswrapper or I shouldn't even ask here? LOL.

Apart from the fact that you are introducing an undebuggable binary
blob into the kernel, there are no problems... :-)

>
> If there are known easy/difficult cards on a faq/list somewhere I thought that
> would help as driver support seems to be a big issue.
>
>
>
>
>
>
>
> ----------------------------------------
>> From: netrolller.3d@gmail.com
>> Date: Mon, 21 Dec 2009 15:14:25 +0100
>> Subject: Re: I need a card that works reasonably easily with Debain- reccs?
>> To: marchywka@hotmail.com
>> CC: linux-wireless@vger.kernel.org
>>
>> Ndiswrapper is not supported in any way, and is probably not the best
>> way to get your card to work.
>> What card do you have currently?
>>
>> Peace,
>> Gábor
>>
>> On Mon, Dec 21, 2009 at 1:49 PM, Mike Marchywka  wrote:
>>>
>>> Hi,
>>> I gave up on windoze after all the apps became too bloated to tolerate
>>> and it didn't seem I should need 1Gbyte to post on a forum without
>>> the browser tying up my disk on VM for minutes on each character I
>>> typed. Debian has worked much better but I can't get my current
>>> wireless card to work well through ndiswrapper. I'm getting inconsistent
>>> results but can download via windozeon another machine and get fast
>>> xfer over eth0. I'm going out to buy a new card, what should I get?
>>>
>>>
>>> Thanks.
>>>
>>>
>>>
>>>
>>> note new address
>>> Mike Marchywka
>>> 1975 Village Round
>>> Marietta GA 30064
>>> 415-264-8477 (w)<- use this
>>> 404-788-1216 (C)<- leave message
>>> 989-348-4796 (P)<- emergency only
>>> marchywka@hotmail.com
>>> Note: If I am asking for free stuff, I normally use for hobby/non-profit
>>> information but may use in investment forums, public and private.
>>> Please indicate any concerns if applicable.
>>>
>>>
>>>
>>>
>>> _________________________________________________________________
>>> Hotmail: Free, trusted and rich email service.
>>> http://clk.atdmt.com/GBL/go/171222984/direct/01/--
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>>
>> --
>> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> _________________________________________________________________
> Your E-mail and More On-the-Go. Get Windows Live Hotmail Free.
> http://clk.atdmt.com/GBL/go/171222985/direct/01/



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
