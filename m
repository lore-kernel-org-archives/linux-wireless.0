Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:59375 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab3BKWkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 17:40:25 -0500
Received: by mail-we0-f182.google.com with SMTP id t57so5315669wey.41
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 14:40:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360355818.5851.19.camel@marlon-Z68X-UD3H-B3>
References: <1360355818.5851.19.camel@marlon-Z68X-UD3H-B3>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 12 Feb 2013 09:40:03 +1100
Message-ID: <CAGRGNgWf2OHfr-aRbTa2WiTBMVEVtwc7pAz6dHh1-U3DYknbMA@mail.gmail.com> (sfid-20130211_234030_059407_58D61B4E)
Subject: Re: Compile for ARM
To: Marlon Smith <marlon.smith10@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marlon,

On Sat, Feb 9, 2013 at 7:36 AM, Marlon Smith <marlon.smith10@gmail.com> wrote:
> Hi everyone,
>
> I'm having some problems with the Ralink supplied driver for my RT3070
> USB dongle, so I'd like to try using your driver instead.  I downloaded
> compat-wireless-2012-12-18 and I would like to compile it for ARM.
> Running ./scripts/driver-select rt2x00 complains about i686 stuff (which
> it should), and I figure I need to set some configuration option to
> compile for ARM instead.
>
> Can anyone point me in the right direction for this?

You'll need, at the very least, the source of the kernel on the
device, and to cross compile it for the specific ARM variant that your
board has.

I'm not sure what specifically you have to do to do this with compat
wireless, but for kernel compiles, it's a matter of saying something
along the line of:

make ARCH=xxxxxx CROSS_COMPILE=arm-compiler-prefix

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
