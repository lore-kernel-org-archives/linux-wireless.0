Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:56210 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbZFJTkx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 15:40:53 -0400
Received: by bwz9 with SMTP id 9so1003783bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 12:40:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ocsvswxa.fsf@litku.valot.fi>
References: <f76a32050906081007q19e9361w8c1fad6fc73c47e7@mail.gmail.com>
	<f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com>
	<3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com>
	<69e28c910906090426l4c383665rdc4bffc501085661@mail.gmail.com>
	<3ace41890906092018o76b0ee62n91819779a8ccd6db@mail.gmail.com>
	<1244619027.18481.55.camel@johannes.local> <20090610113158.GA2798@tuxdriver.com>
	<87ws7jsxqt.fsf@litku.valot.fi> <20090610192825.GA23353@jm.kir.nu>
	<87ocsvswxa.fsf@litku.valot.fi>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 10 Jun 2009 21:40:34 +0200
Message-ID: <69e28c910906101240x10cb1c99h67bd43e450f0121b@mail.gmail.com>
Subject: Re: Testing AP mode with WLAN-USB-Stick: How to obtain?
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2009 at 9:36 PM, Kalle Valo<kalle.valo@iki.fi> wrote:
> Jouni Malinen <j@w1.fi> writes:
>
>>> Also deliberately breaking 802.11 specification sounds very wrong to me.
>>> We can, and should, aim higher than that.
>>
>> Well, breaking specifications may have to be done in some cases ;-), but
>> this particular feature is not really such a case.
>
> Yes, you are correct (as usual). The specification is not perfect, far
> from it :)
>
>> However, I do understand the desire to be able to use some kind of AP
>> mode even if it is known to be broken for some cases.
>
> Actually what are the reasons why an user would prefer AP mode over
> Ad-Hoc mode, if he doesn't care about power save? Better coverage
> between clients and better encryption, but that's it. Right?
>
> --
> Kalle Valo
>

There might be another reason - I'm not sure whether all versions of
Windows are capable of using an ad-hoc network for Internet connection
sharing. So, to bridge the connection from a Linux machine to a
Windows one, one might need to use AP mode.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
