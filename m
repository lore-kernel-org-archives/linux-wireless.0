Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45325 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3COAKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 20:10:52 -0400
Received: by mail-wi0-f169.google.com with SMTP id l13so63427wie.0
        for <linux-wireless@vger.kernel.org>; Thu, 14 Mar 2013 17:10:50 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 14 Mar 2013 17:10:50 -0700
Message-ID: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com> (sfid-20130315_011054_733480_7572FE3C)
Subject: Announcement: open source AR9380 and later HAL
From: Adrian Chadd <adrian@freebsd.org>
To: ath9k-devel <ath9k-devel@lists.ath9k.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I just realised I forgot to announce this here!

I've been working on open sourcing the QCA 10.x mainline AR9380 HAL.
It's passed legal approval (well, last week!) and you can now find it
online:

https://github.com/qca/qcamain_open_hal_public

Now, the 30 second FAQ:

* It's from Nov 27, 2012 - which means there are a few things that
have changed since then - so don't use it as an authoritative
reference compared to ath9k without doing much more digging! ;
* It's missing certain things - including but not limited to
EEPROM/OTP write, TX beamforming, spectral scan (but this will change
later), fast channel change, various calibration and debug modes which
are used for manufacturing;
* It (mostly) compiles and runs as-is, if you're a FreeBSD user and
have a HAL framework to compile it against.

I've done this so open source developers can see a known good and
working version of the chipset support for the AR9380 and later.

If you check out my personal git fork:

https://github.com/erikarn/qcamain_open_hal_public

You'll see that I have a branch (local/freebsd) which contains the
(mostly mechanical!) changes to FreeBSD in order to use it. And yes,
this branch does compile and run in FreeBSD, giving me AR9380 and
later chipset support.

I have an update underway to bring it up to the latest code (well, as
of March 13, 2013) and I'll send out another announcement once that's
done.

I'll also work with legal and engineering teams to get further
features opened up.

Thanks and enjoy!



Adrian
