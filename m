Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:1887 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbYKNNjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 08:39:51 -0500
Received: by qw-out-2122.google.com with SMTP id 3so829698qwe.37
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 05:39:50 -0800 (PST)
Message-ID: <69e28c910811140539p57fa13dej4c13aa0d09c76f95@mail.gmail.com> (sfid-20081114_143956_622656_B09502F4)
Date: Fri, 14 Nov 2008 14:39:50 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: Master mode in iw
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Mark Ryden" <markryde@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <87fxlu4rdx.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <dac45060811130246n41c9983fx2f06f85946b20c1c@mail.gmail.com>
	 <87ej1f6ggq.fsf@nokia.com>
	 <dac45060811130349k3153fcd6i9e6f35f9df3f52ef@mail.gmail.com>
	 <87wsf74z6f.fsf@nokia.com> <1226578011.5105.8.camel@johannes.berg>
	 <87fxlu4rdx.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 9:56 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>
>>> > My question is - is there something inherent which prevents
>>> > implementing it with "iw"? When comparing to the old set of tools,
>>> > which includes iwconifg, "iwconfig wlan0 mode Master" works on some
>>> > interfaces.
>>>
>>> Just guessing, but most probably because there are no drivers which
>>> use nl80211 and support AP mode without hostapd, so nobody hasn't
>>> bothered to implement it, yet.
>>
>> And there never will be since we don't want the whole AP MLME in the
>> kernel regardless of the driver.
>
> Actually I was thinking about fullmac hardware which support AP mode.
> In theory we might need to support those, but I guess in practise
> there hasn't been, nor ever will be, such hardware. I'll just shut up
> now :)
>
> --
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I doubt that any fullmac hardware should have a mac80211-based driver...

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
