Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:17689 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbZGIL67 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 07:58:59 -0400
Received: by fg-out-1718.google.com with SMTP id e21so34102fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2009 04:58:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f76a32050907082230r7b98c438ybf08d1a421717ad6@mail.gmail.com>
References: <f76a32050907061006k3bed082fg3428a50370b0889b@mail.gmail.com>
	 <1246900337.20908.15.camel@johannes.local>
	 <f76a32050907061320n18f3c4c9j4d5589c9c9e45c02@mail.gmail.com>
	 <f76a32050907082230r7b98c438ybf08d1a421717ad6@mail.gmail.com>
Date: Thu, 9 Jul 2009 13:58:56 +0200
Message-ID: <a32f33a40907090458j73b714d6w2fb0648d61beea08@mail.gmail.com>
Subject: Re: rt73 in AP mode: PS frames buffered but missing TIM bit?
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stefan Steuerwald <salsasepp@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 9, 2009 at 7:30 AM, Stefan
Steuerwald<salsasepp@googlemail.com> wrote:
>> > Sounds like a driver problem, it must not be reacting to set_tim()
>> > properly.
>> >
>> > johannes
>>
>> Looking at rt73usb.c:2242, there isn't any initializer for .set_tim .
>> Plausible explanation.
>> It may be totally beyond me to just implement it. Let me find someone
>> to ask nicely ;-) ...
>
> I have an experimental patch working (sent for review to the rt2x00
> mailing list).
> I will report back here.

Are you sure you've send it already? Because I haven't seen anything yet.

Ivo
