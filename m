Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51658 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab1ERJQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 05:16:22 -0400
Received: by wya21 with SMTP id 21so1020432wya.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 02:16:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <444460.90936.qm@web161614.mail.bf1.yahoo.com>
References: <444460.90936.qm@web161614.mail.bf1.yahoo.com>
Date: Wed, 18 May 2011 14:46:21 +0530
Message-ID: <BANLkTi=3i6LEYFivGYB0OZDKmjXxeo+yrQ@mail.gmail.com> (sfid-20110518_111627_016294_548C8379)
Subject: Re: rt2x00: rt2800usb causing kernel panic /compat-wireless/
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	gwingerde@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 18, 2011 at 1:48 PM, Walter Goldens
<goldenstranger@yahoo.com> wrote:
> A very peculiar bug.
>
> With compat-wireless from 16.05 a nasty bug started to manifest itself. Right around association time, the rt2800usb causes kernel panic. The system freezes and the Caps Lock and Num Lock leds on the keyboard begin to flash.

also ath9k, iwlagn.

>
> Unfortunately there are no recoverable traces after the system failure to aid this bug report or to indicate its origin.
>
> I believe it may somehow be related to Ubuntu's network-manager. If I turn off the network-manager service, I can go into monitor mode for example, but if network-manager is running and I plug my USB dongle, it starts to associate, a second or two later the system is in complete meltdown.

same thing, monitor mode worked perfectly fine.

>
> Nothing concrete, but a hunch is telling me this has something to do with the association mechanism of the rt2800usb. Compat-wireless from few days back exhibits no such foul play.

yes just right at the association complete freeze.

>
> Walter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
