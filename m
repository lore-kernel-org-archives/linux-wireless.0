Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm16-vm1.bullet.mail.bf1.yahoo.com ([98.139.213.131]:21793 "HELO
	nm16-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932763Ab1ERL4Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 07:56:16 -0400
Message-ID: <294183.47547.qm@web161601.mail.bf1.yahoo.com> (sfid-20110518_135630_355959_56549472)
Date: Wed, 18 May 2011 04:56:15 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: rt2x00: rt2800usb causing kernel panic /compat-wireless/
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	gwingerde@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
In-Reply-To: <BANLkTi=3i6LEYFivGYB0OZDKmjXxeo+yrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > A very peculiar bug.
> >
> > With compat-wireless from 16.05 a nasty bug started to
> manifest itself. Right around association time, the
> rt2800usb causes kernel panic. The system freezes and the
> Caps Lock and Num Lock leds on the keyboard begin to flash.
> 
> also ath9k, iwlagn.
> 
> >
> > Unfortunately there are no recoverable traces after
> the system failure to aid this bug report or to indicate its
> origin.
> >
> > I believe it may somehow be related to Ubuntu's
> network-manager. If I turn off the network-manager service,
> I can go into monitor mode for example, but if
> network-manager is running and I plug my USB dongle, it
> starts to associate, a second or two later the system is in
> complete meltdown.
> 
> same thing, monitor mode worked perfectly fine.
> 
> >
> > Nothing concrete, but a hunch is telling me this has
> something to do with the association mechanism of the
> rt2800usb. Compat-wireless from few days back exhibits no
> such foul play.
> 
> yes just right at the association complete freeze.
> 

That's strange. I wonder what's the connection with this bug and network-manager. Because when I manually tried to associate, dmesg reported the association attempt timed out.

Walter
