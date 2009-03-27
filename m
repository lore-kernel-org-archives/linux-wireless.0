Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45278 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759731AbZC0PNN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 11:13:13 -0400
Received: by fxm2 with SMTP id 2so1069004fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 08:13:10 -0700 (PDT)
To: Davide Pesavento <davidepesa@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath9k and power management
References: <2da21fe50903270727m7b7007ctaa846aea61902436@mail.gmail.com>
	<87ljqr58oa.fsf@litku.valot.fi>
	<2da21fe50903270754i26c8be08i206b12a268214f56@mail.gmail.com>
	<2da21fe50903270807t25962a00w1a5da870641421ea@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 27 Mar 2009 17:13:07 +0200
In-Reply-To: <2da21fe50903270807t25962a00w1a5da870641421ea@mail.gmail.com> (Davide Pesavento's message of "Fri\, 27 Mar 2009 16\:07\:28 +0100")
Message-ID: <87hc1f5798.fsf@litku.valot.fi> (sfid-20090327_161333_442167_B7FC8109)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Davide Pesavento <davidepesa@gmail.com> writes:

>>> It might be that ath9k doesn't work when timeout is zero (which 'power
>>> on' effectively does). You need a fairly new wireless-tools to set the
>>> timeout, older versions had a bug with that.
>>>
>>
>> What do you mean by "fairly new"? I have wireless-tools version 29
>> installed, which is the latest stable. Do I need to use version 30
>> beta?
>>
>
> Nevermind, I guess I need the beta version... :-)
>
> # iwconfig wlan0 power timeout 3
> Error for wireless request "Set Power Management" (8B2C) :
>     invalid argument "3".

Yeah, you need the beta version. I used version 30-pre7 myself.

-- 
Kalle Valo
