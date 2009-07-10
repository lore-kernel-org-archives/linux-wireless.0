Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:37785 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbZGJJIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 05:08:17 -0400
Received: by bwz25 with SMTP id 25so721784bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2009 02:08:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a32f33a40907090458j73b714d6w2fb0648d61beea08@mail.gmail.com>
References: <f76a32050907061006k3bed082fg3428a50370b0889b@mail.gmail.com>
	 <1246900337.20908.15.camel@johannes.local>
	 <f76a32050907061320n18f3c4c9j4d5589c9c9e45c02@mail.gmail.com>
	 <f76a32050907082230r7b98c438ybf08d1a421717ad6@mail.gmail.com>
	 <a32f33a40907090458j73b714d6w2fb0648d61beea08@mail.gmail.com>
Date: Fri, 10 Jul 2009 11:08:16 +0200
Message-ID: <f76a32050907100208h3a8a3141l8fdf17f2448c0ce7@mail.gmail.com>
Subject: Re: rt73 in AP mode: PS frames buffered but missing TIM bit?
From: Stefan Steuerwald <salsasepp@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With Ivo's help, we have a tested patch. Ivo will take care of
submitting it and extending it to all rt2x00 drivers.
I love it when things just work out!

Thank you,
  Stefan.

2009/7/9 Ivo Van Doorn <ivdoorn@gmail.com>:
> On Thu, Jul 9, 2009 at 7:30 AM, Stefan
> Steuerwald<salsasepp@googlemail.com> wrote:
>>> > Sounds like a driver problem, it must not be reacting to set_tim()
>>> > properly.
>>> >
>>> > johannes
>>>
>>> Looking at rt73usb.c:2242, there isn't any initializer for .set_tim .
>>> Plausible explanation.
>>> It may be totally beyond me to just implement it. Let me find someone
>>> to ask nicely ;-) ...
>>
>> I have an experimental patch working (sent for review to the rt2x00
>> mailing list).
>> I will report back here.
>
> Are you sure you've send it already? Because I haven't seen anything yet.
>
> Ivo
>
