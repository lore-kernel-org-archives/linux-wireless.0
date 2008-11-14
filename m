Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:50892 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbYKNI5Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 03:57:16 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: Mark Ryden <markryde@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Master mode in iw
References: <dac45060811130246n41c9983fx2f06f85946b20c1c@mail.gmail.com>
	<87ej1f6ggq.fsf@nokia.com>
	<dac45060811130349k3153fcd6i9e6f35f9df3f52ef@mail.gmail.com>
	<87wsf74z6f.fsf@nokia.com> <1226578011.5105.8.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Fri, 14 Nov 2008 10:56:58 +0200
In-Reply-To: <1226578011.5105.8.camel@johannes.berg> (ext Johannes Berg's message of "Thu\, 13 Nov 2008 13\:06\:51 +0100")
Message-ID: <87fxlu4rdx.fsf@nokia.com> (sfid-20081114_095721_421330_A3FF08A1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> > My question is - is there something inherent which prevents
>> > implementing it with "iw"? When comparing to the old set of tools,
>> > which includes iwconifg, "iwconfig wlan0 mode Master" works on some
>> > interfaces.
>> 
>> Just guessing, but most probably because there are no drivers which
>> use nl80211 and support AP mode without hostapd, so nobody hasn't
>> bothered to implement it, yet.
>
> And there never will be since we don't want the whole AP MLME in the
> kernel regardless of the driver.

Actually I was thinking about fullmac hardware which support AP mode.
In theory we might need to support those, but I guess in practise
there hasn't been, nor ever will be, such hardware. I'll just shut up
now :)

-- 
Kalle Valo
