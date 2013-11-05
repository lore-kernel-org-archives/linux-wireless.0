Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp21.mail.ru ([94.100.176.174]:42304 "EHLO smtp21.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab3KEJMv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 04:12:51 -0500
Message-ID: <5278B68E.5070807@mail.ru> (sfid-20131105_101304_608146_24E07CE4)
Date: Tue, 05 Nov 2013 13:12:46 +0400
From: Alexander Varnin <fenixk19@mail.ru>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
	Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: mwifiex_sdio on chromebook
References: <5276491F.20207@mail.ru> <477F20668A386D41ADCC57781B1F70430F45757E63@SC-VEXCH1.marvell.com> <527703E6.8040504@mail.ru> <477F20668A386D41ADCC57781B1F70430F45758053@SC-VEXCH1.marvell.com> <5278AE8E.9060203@mail.ru> <5278B1EC.8020000@broadcom.com>
In-Reply-To: <5278B1EC.8020000@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

05.11.2013 12:53, Arend van Spriel пишет:
>>>
>>
>> It is ported at most already and mainline kernel works good on
>> Chromebook. It is just peripheral problem.
>
> Not sure how chromium os architecture looks like, but you mean to say
> *you* ported code in chromium user-space to work with
> upstream/mainline kernel API's? 

No. There is work doing by somebody from google or somewhere else, by
making mainline kernel work on Chromebook. Kernel 3.11 is the first
mainline kernel, that is able to boot and work on Chromebook. Working
parts is MMC controller, display controller, keyboard, etc. Not working
is usb, wifi, rtc, temperature sensors, etc.

By a tradition of open source, as I am interested, and I have experience
in kernel development, I have decided to debug wifi issue by myself. I
don't know, why I should port anything. Everything that was needed is
already ported - there is Chromebook device tree in kernel, there is all
required drivers. There is just a problem with powering up Marvell wifi
chip. I don't see, why fixing it requires any complex porting.

One thing worth doing is to compare 3.4 from chromeos and 3.4 mainline,
and find, if there any specific wifi changes. But there is possibly not.
