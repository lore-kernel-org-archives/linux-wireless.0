Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39364 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbYIIIAv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 04:00:51 -0400
Message-ID: <48C62B82.3030700@atheros.com> (sfid-20080909_100056_147406_1BCBA789)
Date: Tue, 9 Sep 2008 13:23:38 +0530
From: vasanthakumar thiagarajan <vasanth.thiagarajan@atheros.com>
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Marcel Holtmann <marcel@holtmann.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] Ath9k: Add RF kill support.
References: <20080906123842.GA27504@vasanth-lnx.users.atheros.com> <1220721347.6714.114.camel@californication> <20080908045926.GA28149@vasanth-lnx.users.atheros.com> <20080908151057.GB22081@khazad-dum.debian.net>
In-Reply-To: <20080908151057.GB22081@khazad-dum.debian.net>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> On Mon, 08 Sep 2008, Vasanthakumar Thiagarajan wrote:
>   
>> On Sat, Sep 06, 2008 at 10:45:47PM +0530, Marcel Holtmann wrote:
>>     
>>>> CONFIG_ATH9K_RFKILL needs to be set
>>>> to enable this support.
>>>>         
>>> why do we have to introduce yet another config option for this? What is
>>> the advantage of disabling RFKILL support? I really don't see it and all
>>> these extra config options are rather confusing than useful.
>>>       
>> Normally home users may not hit a situation where they have to
>> disable the radio, so they can compile out the rf kill support
>> and essentially disable the periodic run of the work queue
>> (rfkill_poll ,runs for every 2 secs).If this does not make
>> any sense, I will remove this config option.
>>     
>
> What doesn't make sense at all is to have it manually selectable.  Just
> define it to the same value of CONFIG_RFKILL, or use CONFIG_RFKILL directly
> outright.
>   
ok, thanks.

Vasanth
