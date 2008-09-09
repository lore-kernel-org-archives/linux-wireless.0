Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39270 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbYIIQWi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 12:22:38 -0400
Message-ID: <48C6A118.7030205@atheros.com> (sfid-20080909_182242_355782_7B147EAD)
Date: Tue, 9 Sep 2008 21:45:20 +0530
From: vasanthakumar thiagarajan <vasanth.thiagarajan@atheros.com>
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: Add RF kill support
References: <20080909153422.GA7651@vasanth-lnx.users.atheros.com> <1220975170.31304.184.camel@johannes.berg> <48C69E11.5090102@atheros.com> <20080909161533.GA31478@khazad-dum.debian.net>
In-Reply-To: <20080909161533.GA31478@khazad-dum.debian.net>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> On Tue, 09 Sep 2008, vasanthakumar thiagarajan wrote:
>   
>> I just rearranged (purely change in the location of few static functions
>> in the file) the code to avoid
>> the prototype declaration of the functions which are called (before
>> their definition) in case of any
>> failure during rfkill_register().
>>     
>
> That's much better done in two patches.
>
> The first patch should just move code around without changing *anything*.
> You can check the resulting binary to be sure you didn't change any code by
> mistake.
>
> The second patch does the real code changes.
>
> --
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh
>   
Yeah, I got it. Thanks.

Vasanth


