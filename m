Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:42505 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbYK0OFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 09:05:31 -0500
Received: by ey-out-2122.google.com with SMTP id 6so429528eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2008 06:05:29 -0800 (PST)
Message-ID: <f76a32050811270605s606cc0acjd419987235db44f4@mail.gmail.com> (sfid-20081127_150536_022334_1C0DA603)
Date: Thu, 27 Nov 2008 15:05:29 +0100
From: "Stefan Steuerwald" <salsasepp@googlemail.com>
To: "Christian Lamparter" <chunkeey@web.de>
Subject: Re: p54: AP mode: no data frame despite traffic indication set in TIM
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200811271206.30851.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200811242124.16358.chunkeey@web.de>
	 <200811262213.03751.chunkeey@web.de>
	 <f76a32050811270057r69df8f38p9cb4129bd98ce575@mail.gmail.com>
	 <200811271206.30851.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The v3 patch (together with the other two) works flawlessly for 1.5
hours now, under app-level traffic.
I will remove 80211 debugging from the kernel and try again for a
longer period, but looking good.

I'm unfamiliar with kernel dev procedure. I assume you guys are trying
to get confirmation for that and/or submit patches? If you need me for
any of that, I'll be there anytime. Also, a hint on whether to send
pizzas or iPods would be appreciated ;-) .

Thank you all for this marathon of a helpdesk session!!!
  Stefan.

(and - ahem - I'm one of those customers coming back for more...)


2008/11/27 Christian Lamparter <chunkeey@web.de>:
> On Thursday 27 November 2008 09:57:11 Stefan Steuerwald wrote:
>> At least I haven't observed the crash in the last 60 minutes, whereas
>> before it took only 1-2 minutes every time to turn it up.
>> Will test this all day.
>
> Finally!
>
>> The three patches mentioned before are applied, and my app-level
>> timeout is still gone, and the "dropped filtered TX" messages are gone
>> as well.
>>
>> Christian, should I actually test your p54-sta-flags-v3 patch?
>>
> Yes, of course... v1 and v2 had a stupid "full queue" bug in p54_tx/p54_tx_fill.
> So let me know if your ipod still works with v3.
>
> Regards,
>        Chr
>
