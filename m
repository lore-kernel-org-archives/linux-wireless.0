Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:45822 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab0BOLbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 06:31:37 -0500
Received: by fxm7 with SMTP id 7so5569277fxm.28
        for <linux-wireless@vger.kernel.org>; Mon, 15 Feb 2010 03:31:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <912ec82a1002150037y2a187032h73e3d45188eabbc7@mail.gmail.com>
References: <912ec82a1002140957p6959c030h2b33fd9646cfd67d@mail.gmail.com>
	<69e28c911002141046r70d8bcf2g6a8db7afbbef837@mail.gmail.com>
	<20100214191126.GA13637@jm.kir.nu> <69e28c911002141150t66d2c98dia3730deaac9a7cbc@mail.gmail.com>
	<912ec82a1002150037y2a187032h73e3d45188eabbc7@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 15 Feb 2010 12:31:15 +0100
Message-ID: <69e28c911002150331l39ae5a8fm7b5306da6a20a3b8@mail.gmail.com>
Subject: Re: good wlan: sniffer that does not need a windows machine ?
To: Neshama Parhoti <pneshama@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/2/15 Neshama Parhoti <pneshama@gmail.com>:
>>>> Monitoring in general works in almost all linux drivers
>
> So I can just start monitoring with my thinkpad ?
>
> And I will get to see stuff like transmission rate and power levels ?

Basically yes, though some drivers, notably zd1211rw doesn't report
power levels. Also, HT packets don't yet show correct TX rates in the
radiotap header. (But apparently they are displayed now, only the MCS
index is missing!)

>
> What software do I use for that ? Wireshark ?

Yes - use a recent version to correctly decode the radiotap header.

>
> So really, no need to buy those (obnoxious)  USB dongle or PCMCIA
> cards that needs windows ?  That's great news!!
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
