Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44476 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab3DAWVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 18:21:00 -0400
Received: by mail-wg0-f42.google.com with SMTP id k13so2555397wgh.5
        for <linux-wireless@vger.kernel.org>; Mon, 01 Apr 2013 15:20:59 -0700 (PDT)
Message-ID: <515A0847.7000306@gmail.com> (sfid-20130402_002105_808827_3A224A0F)
Date: Tue, 02 Apr 2013 01:20:55 +0300
From: Nick Kossifidis <mickflemm@gmail.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Subject: Re: Announcement: open source AR9380 and later HAL
References: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com>
In-Reply-To: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri Mar 15 02:10:50 2013, Adrian Chadd wrote:
> Hi,
>
> I just realised I forgot to announce this here!
>
> I've been working on open sourcing the QCA 10.x mainline AR9380 HAL.
> It's passed legal approval (well, last week!) and you can now find it
> online:
>
> https://github.com/qca/qcamain_open_hal_public
>
> Now, the 30 second FAQ:
>
> * It's from Nov 27, 2012 - which means there are a few things that
> have changed since then - so don't use it as an authoritative
> reference compared to ath9k without doing much more digging! ;
> * It's missing certain things - including but not limited to
> EEPROM/OTP write, TX beamforming, spectral scan (but this will change
> later), fast channel change, various calibration and debug modes which
> are used for manufacturing;
> * It (mostly) compiles and runs as-is, if you're a FreeBSD user and
> have a HAL framework to compile it against.
>
> I've done this so open source developers can see a known good and
> working version of the chipset support for the AR9380 and later.
>
> If you check out my personal git fork:
>
> https://github.com/erikarn/qcamain_open_hal_public
>
> You'll see that I have a branch (local/freebsd) which contains the
> (mostly mechanical!) changes to FreeBSD in order to use it. And yes,
> this branch does compile and run in FreeBSD, giving me AR9380 and
> later chipset support.
>
> I have an update underway to bring it up to the latest code (well, as
> of March 13, 2013) and I'll send out another announcement once that's
> done.
>
> I'll also work with legal and engineering teams to get further
> features opened up.
>
> Thanks and enjoy!
>
>
>
> Adrian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks a lot Adrian !
Keep it up :-)
