Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:63074 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab3BKWwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 17:52:54 -0500
Received: by mail-pa0-f47.google.com with SMTP id bj3so3262191pad.20
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 14:52:53 -0800 (PST)
Subject: Re: Compile for ARM
From: Marlon Smith <marlon.smith10@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAGRGNgWf2OHfr-aRbTa2WiTBMVEVtwc7pAz6dHh1-U3DYknbMA@mail.gmail.com>
References: <1360355818.5851.19.camel@marlon-Z68X-UD3H-B3>
	 <CAGRGNgWf2OHfr-aRbTa2WiTBMVEVtwc7pAz6dHh1-U3DYknbMA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Feb 2013 14:52:49 -0800
Message-ID: <1360623169.7984.1.camel@marlon-Z68X-UD3H-B3> (sfid-20130211_235258_163290_259D852F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the replies guys.  After some investigating, the problem may
lie somewhere other than the wireless driver.  I'm going to pursue that
avenue for now, but if I hit a dead end I will come back to this.

Thanks again for the help.

Marlon

On Tue, 2013-02-12 at 09:40 +1100, Julian Calaby wrote:
> Hi Marlon,
> 
> On Sat, Feb 9, 2013 at 7:36 AM, Marlon Smith <marlon.smith10@gmail.com> wrote:
> > Hi everyone,
> >
> > I'm having some problems with the Ralink supplied driver for my RT3070
> > USB dongle, so I'd like to try using your driver instead.  I downloaded
> > compat-wireless-2012-12-18 and I would like to compile it for ARM.
> > Running ./scripts/driver-select rt2x00 complains about i686 stuff (which
> > it should), and I figure I need to set some configuration option to
> > compile for ARM instead.
> >
> > Can anyone point me in the right direction for this?
> 
> You'll need, at the very least, the source of the kernel on the
> device, and to cross compile it for the specific ARM variant that your
> board has.
> 
> I'm not sure what specifically you have to do to do this with compat
> wireless, but for kernel compiles, it's a matter of saying something
> along the line of:
> 
> make ARCH=xxxxxx CROSS_COMPILE=arm-compiler-prefix
> 
> Thanks,
> 


