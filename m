Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:55656 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab0KVTNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 14:13:48 -0500
Received: by pxi15 with SMTP id 15so1619352pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 11:13:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <370521.43644.qm@web29514.mail.ird.yahoo.com>
References: <4CEA9903.6070604@lwfinger.net> <370521.43644.qm@web29514.mail.ird.yahoo.com>
From: Klaas De Craemer <klaasdc@gmail.com>
Date: Mon, 22 Nov 2010 20:13:26 +0100
Message-ID: <AANLkTimd0EDGtZFcrhknyacoCQQZNMEKe-kvYNA9z_Bo@mail.gmail.com>
Subject: Re: RTL8187L: Can only "enable" hw radio switch after Windows boot
To: htl10@users.sourceforge.net
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 22, 2010 at 17:40, Hin-Tak Leung
<htl10@users.sourceforge.net> wrote:
> --- On Mon, 22/11/10, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
>> Date: Monday, 22 November, 2010, 16:23
>> On 11/22/2010 02:59 AM, Klaas De
>> Craemer wrote:
>> >
>> > Sorry, I meant I get a few errors in the form of
>> "SIOCSIFFLAGS:
>> > Unknown error 132" on the stdout when trying to bring
>> up the blocked
>> > interface.
>>
>> Do those errors also occur when it works, or just when it
>> is blocked?

The errors only occur when blocked. As Sven-Haegar Koch remarked, this
behaviour is similar to the iwlagn driver for example with the switch
turned off.

>>
>> Is it possible to keep the box in a warm place to see if it
>> is temperature
>> related? The problem of it working with Windows is still
>> puzzling. As your Atom

Not sure if you meant this, but the box itself is inside (warm), only
the transceiver is outside.
Just to be sure, I skipped trying it in Linux first today and
immediately plugged it in my Windows laptop: instant connection. Next
I plugged it in Linux and it works fine. This way the device had no
time to "warm up" because of first being powered in Linux.

I cannot easily take it inside without unscrewing the antenna (a dish
with biquad feeder). So I'll try it without antenna tomorrow.

>> is 32 bit, there is the possibility of trying ndiswrapper
>> with the Windows XP
>> driver. Oh it hurts to write that, but that would isolate
>> the problem to rtl8187.

That is going to be a bit difficult as the box is currently headless,
runs from a 4GB SSD and has no CD drive. But I'll see what I can do.
Would the results also be meaningful if I just ran plain/native
Windows XP on it to test the drivers?

>
> I was going to comment if the problem is warm-reboot/cool-reboot related. I had an impression at some point in the past that the windows driver messes with the internal state of the 8187B device, such that it does not work under linux after a warm-boot from windows (i.e. you need to do "shutdown" in windows and presses the power-switch to go into linux, rather than "reboot", and select "linux" at the boot-loader prompt). Although I don't think this is the current situation - I don't often warm-reboot, and in any case, seldomly use wireless under windows - I think the in-kernel driver these days reset the device's state on start-up better or something, so my impression may not be valid; but if you are using a slightly older in-kernel driver, in combination with rebooting to windows, etc, that might be the case.
>

I'm not rebooting the Atom machine to Windows, just unplugging and
plugging the usb cable into a Windows laptop. I guess that counts as a
cold-boot.


Thanks for your input so far!
Klaas

>
>
>
>
