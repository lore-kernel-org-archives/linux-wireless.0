Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55136 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012Ab1ERMls (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 08:41:48 -0400
Received: by wwa36 with SMTP id 36so1667531wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 05:41:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <294183.47547.qm@web161601.mail.bf1.yahoo.com>
References: <BANLkTi=3i6LEYFivGYB0OZDKmjXxeo+yrQ@mail.gmail.com>
	<294183.47547.qm@web161601.mail.bf1.yahoo.com>
Date: Wed, 18 May 2011 18:11:46 +0530
Message-ID: <BANLkTimwBB35HhOBjOq=OyhrVWq9MOZ3tA@mail.gmail.com> (sfid-20110518_144151_361138_9FDD6133)
Subject: Re: rt2x00: rt2800usb causing kernel panic /compat-wireless/
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	gwingerde@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 18, 2011 at 5:26 PM, Walter Goldens
<goldenstranger@yahoo.com> wrote:
>> > A very peculiar bug.
>> >
>> > With compat-wireless from 16.05 a nasty bug started to
>> manifest itself. Right around association time, the
>> rt2800usb causes kernel panic. The system freezes and the
>> Caps Lock and Num Lock leds on the keyboard begin to flash.
>>
>> also ath9k, iwlagn.
>>
>> >
>> > Unfortunately there are no recoverable traces after
>> the system failure to aid this bug report or to indicate its
>> origin.
>> >
>> > I believe it may somehow be related to Ubuntu's
>> network-manager. If I turn off the network-manager service,
>> I can go into monitor mode for example, but if
>> network-manager is running and I plug my USB dongle, it
>> starts to associate, a second or two later the system is in
>> complete meltdown.
>>
>> same thing, monitor mode worked perfectly fine.
>>
>> >
>> > Nothing concrete, but a hunch is telling me this has
>> something to do with the association mechanism of the
>> rt2800usb. Compat-wireless from few days back exhibits no
>> such foul play.
>>
>> yes just right at the association complete freeze.
>>
>
> That's strange. I wonder what's the connection with this bug and network-manager. Because when I manually tried to associate, dmesg reported the association attempt timed out.

no even when we use iw dev connect command we can see the panic. some
expert suspected that there is a chance of kfree_rcu in
compat-wireless may have caused the problem

>
> Walter
>



-- 
shafi
