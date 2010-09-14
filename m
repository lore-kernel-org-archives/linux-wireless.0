Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3115 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab0INESY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 00:18:24 -0400
Message-ID: <4C8EF783.2050901@broadcom.com>
Date: Mon, 13 Sep 2010 21:18:11 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
cc: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	=?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>,
	"Hauke Mehrtens" <hauke@hauke-m.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@infradead.org" <mcgrof@infradead.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH 8/8] compat-wireless: add brcm80211 driver
References: <1284221913-22455-1-git-send-email-hauke@hauke-m.de>
 <1284221913-22455-10-git-send-email-hauke@hauke-m.de>
 <AANLkTim8UUHmm_TNzg0Spm7SXm8OXfDAvhjUK7v9V-F=@mail.gmail.com>
 <1284312581.8821.34.camel@maggie>
 <AANLkTikF_089e9kTrV1wFc5a4TnhoZ9ekp2C0r-DMSE1@mail.gmail.com>
 <AANLkTin5mGf51p39Cje_ZpRvjH6LKo2xG4QLiw4W-ybo@mail.gmail.com>
In-Reply-To: <AANLkTin5mGf51p39Cje_ZpRvjH6LKo2xG4QLiw4W-ybo@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/12/2010 02:34 PM, Luis R. Rodriguez wrote:
> On Sun, Sep 12, 2010 at 10:36 AM, Gábor Stefanik
> <netrolller.3d@gmail.com>  wrote:
>> On Sun, Sep 12, 2010 at 7:29 PM, Michael Büsch<mb@bu3sch.de>  wrote:
>>> On Sun, 2010-09-12 at 19:16 +0200, Gábor Stefanik wrote:
>>>> Umm... do we accept staging drivers in compat-wireless?
>>>
>>> Why shouldn't we accept them in compat?
>>>
>>> --
>>> Greetings Michael.
>>>
>>>
>>
>> Dunno, just given the general hostility of the wireless team towards
>> staging drivers.
>
> The idea is to enable users, so I'll gladly accept them, thanks
> haukes, I'll apply after first reviewing your other series.
>

I was going to try and figure out the compat-wireless changes needed to 
enable brcm80211 myself, so the quick contribution on this is much 
appreciated by me if nobody else.

- Henry



