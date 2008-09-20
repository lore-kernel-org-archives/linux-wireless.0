Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:52015 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbYITVD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 17:03:56 -0400
Received: by gxk9 with SMTP id 9so1858459gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 20 Sep 2008 14:03:55 -0700 (PDT)
Message-ID: <43e72e890809201403w2c4511fdv2fe26bbcf49ccdd7@mail.gmail.com> (sfid-20080920_230400_695641_95E01484)
Date: Sat, 20 Sep 2008 14:03:54 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Senthilkumar Balasubramanian"
	<Senthilkumar.Balasubramanian@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1221944338.3023.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <20080919182322.GB7027@tesla>
	 <alpine.LNX.2.00.0809191630090.14961@alcarin.uplinklabs.net>
	 <20080919235305.GD11665@tesla>
	 <f488382f0809191701u2dbf8d22n6015c9f1f23c73be@mail.gmail.com>
	 <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com>
	 <f488382f0809192029w601e0e72x5c3affc3dbe65118@mail.gmail.com>
	 <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com>
	 <43e72e890809201357y1413a151r85aad7cc16440cf4@mail.gmail.com>
	 <1221944338.3023.8.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/9/20 Johannes Berg <johannes@sipsolutions.net>:
> On Sat, 2008-09-20 at 13:57 -0700, Luis R. Rodriguez wrote:
>
>> mcgrof@tesla ~/tmp/irq $ sar -f irqlog-storm.sar -A
>> Invalid system activity file: irqlog-storm.sar
>>
>> Perhaps we its a different format than what my sar can read...
>
> It changes like every release... Not a very useful thing, that.

Ah -- oh well.

OK so yeah you have an interrupt storm, this is evident.

Do you think there is a way you can try to trigger the interrupt storm
so it happens < than after 7 hours or however long its taking you? If
so then it'd be good to get your debug out using the interrupt debug.
If that's not useful then we can enable all debug stuff (file will be
huge).

Try turning on the microwave, turn on all  your bluetooth devices, use
your 2.4 GHz wireless phone, use your xbox 360 controllers and ps3
controllers all at once :D

  Luis
