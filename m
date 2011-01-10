Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63351 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab1AJVx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 16:53:26 -0500
Received: by wyb28 with SMTP id 28so19839493wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 13:53:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <801634.53195.qm@web29514.mail.ird.yahoo.com>
References: <AANLkTi=iDFiuxKiCXCf54uAf4f1Vk-meNf=4J94Bn4a0@mail.gmail.com> <801634.53195.qm@web29514.mail.ird.yahoo.com>
From: Klaas De Craemer <klaasdc@gmail.com>
Date: Mon, 10 Jan 2011 22:49:10 +0100
Message-ID: <AANLkTimFuEqdbhkehBCLYPvi08gVrHuvgve6EE9g4121@mail.gmail.com>
Subject: Re: RTL8187L: Can only "enable" hw radio switch after Windows boot
To: htl10@users.sourceforge.net
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 10, 2011 at 20:10, Hin-Tak Leung
<htl10@users.sourceforge.net> wrote:
> --- On Mon, 10/1/11, Klaas De Craemer <klaasdc@gmail.com> wrote:
>
>> Hello all,
>>
>> I can add to this that the rtl8187 driver seems to perform
>> worse then
>> its Windows counterpart (for this device anyway). Today,
>> the Linux
>> driver could not even connect anymore to the AP. Issuing
>> "iwconfig
>> wlan0 apname" just doesn't do anything. I could connect to
>> another,
>> more closer AP in Linux however.
>> I'm very annoyed to announce that, despite the loss in
>> flexibility, we
>> will be moving this box to Windows because the wireless
>> connection
>> then "just works".
>> I'll still check the list and I will remain available to
>> test anything
>> that could help the Linux driver though.
>
> I would suggest you having a go at studying the windows driver under ndiswrapper, and using the kernel debugfs to study how the windows driver communicate with the device via USB and compared that with what the native driver is doing. That was how I got to be associated with the native driver - spotting what it was doing wrong/different from how the vendor linux driver was doing; the same should work with ndiswrapper+windows driver. (it did for a little bit, from personal experience).
>
> There is no magic to it - if you want the driver to work for you, you can spend some time on it. You know the windows driver works "better" (for you), and there is a way to study the windows driver via ndiswrapper and compared that with the native driver, so it is do-able, just time and patience.
>
> AFAIK, none of us have any special secret knowledge about the RTL8187L, much beyond what's publicly avaialable - i.e. the Realtek "official" driver code and a few spec sheets, and studying the windows driver via ndiswrapper; and AFAIK none of us are paid to work on the Realtek driver - Herton probably are paid to work on linux-things (given the e-mail address) but presumably not specifically on any one driver; I just happened to own a laptop with such a device built-in and Larry seems to be more or less of the same situation.
>
> P.S. I am annoyed by the "I am very annoyed..." part of your e-mail message.
>

My apologies if it sounded that negative. What I meant was that I
enjoy using Linux and that it now bothers me to have to put windows on
something like this. I'm still glad that people like you, Larry and
Herton are willing to put so much effort in developing drivers.

Klaas

>
>
>
