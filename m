Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64880 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849Ab0HKCvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 22:51:33 -0400
Received: by qwh6 with SMTP id 6so8937331qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Aug 2010 19:51:33 -0700 (PDT)
Message-ID: <4C621029.6000607@lwfinger.net>
Date: Tue, 10 Aug 2010 21:51:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: Rogerio Luz Coelho <rogluz.news@gmail.com>,
	=?ISO-8859-1?Q?G=E1bor_?= =?ISO-8859-1?Q?Stefanik?=
	<netrolller.3d@gmail.com>, linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: RTL 8187b - naughty behaviour
References: <4BB773A9.2070703@lwfinger.net> <n2n917a57cb1004031000h9910230ew50c6380788a64b1c@mail.gmail.com> <q2k917a57cb1004100507s17249540xfb11a2e2f0a2dd76@mail.gmail.com> <w2i69e28c911004101150h9db59aa1x2f9d12964f3c3fc1@mail.gmail.com> <y2g917a57cb1004101240g8033e225n57bf68b6d37b5431@mail.gmail.com> <q2k69e28c911004110635nac8100f6pe014361ed0a516a5@mail.gmail.com> <1275579654.1311.32.camel@casa> <AANLkTimKLuiLpV0C+cXOyX2OqJOwB+giVLaHKCMJKVvt@mail.gmail.com> <4C5F5D5C.9040709@lwfinger.net> <AANLkTimQtAOSjfpCx8H3RXu0O+gPbvMQQ3P3-tLmpaiV@mail.gmail.com> <20100811002355.GB5874@barata.holoscopio.com>
In-Reply-To: <20100811002355.GB5874@barata.holoscopio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/10/2010 07:23 PM, Thadeu Lima de Souza Cascardo wrote:
> 
> I've been working for some two weeks observing the behaviour of
> rtl8187B. Thanks to someone's report (I think it was Rogerio's), I found
> the realtek driver. It does seem to work a little better regarding
> transmission. I have taken a look at the driver (it's GPLed) and done
> some experiments, but couldn't find any particular difference that
> magically make it work yet.
> 
> I think the mmiotrace is not exactly what you want. Since these are USB
> devices, usbmon dumps are much more readable and useful. I've made some
> of my own, but still need to write some scripts to translate them to
> something I can read and compare more easily.
> 
> As soon as I get some patches that work for me and are field tested for
> these particular device versions, I will send them to the list for
> review and testing with other device versions.
> 
> Larry, you mentioned in one of your messages about the specs. Are they
> under an NDA or could you provide or ask for a copy?

The spec sheets I have gotten from Realtek are minimal, but I do not have the
right to redistribute them.

> At a glance, the realtek driver seems to do some dynamic power gain
> control. I will try this as one of my next steps.

That sounds like a promising place to start.

Larry


