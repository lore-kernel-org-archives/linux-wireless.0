Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36552 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab1LSNVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 08:21:53 -0500
Received: by iaeh11 with SMTP id h11so8543514iae.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 05:21:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgUQ48Bc4qQeZ8Euj1+z8qiyA4cOEcEsx3B0EO5oh2Cnug@mail.gmail.com>
References: <CAF3gKsxgO16GqP8x4Q_+wUhYK4x919xbik-ATv4agS+Heg3yig@mail.gmail.com>
 <CAGRGNgUQ48Bc4qQeZ8Euj1+z8qiyA4cOEcEsx3B0EO5oh2Cnug@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 20 Dec 2011 00:21:32 +1100
Message-ID: <CAGRGNgXYUmQY4SFtRKrxFqDg+wRqpH4hn1Wu-mq5SowqFibHxQ@mail.gmail.com> (sfid-20111219_142157_390175_BFE1F926)
Subject: Re: Developing Linux tree support for Marvell 88W8335
To: Shahar Or <mightyiampresence@gmail.com>
Cc: libertas-dev@lists.infradead.org, mab@comnets.uni-bremen.de,
	luc@saillard.org, linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Shahar,

Reading your email again, I completely missed the point: you're not
writing a driver, you're donating cards. Sorry for any confusion.

If *anyone* is developing a driver, the following info, as in my
previous email, could be helpful:

On Tue, Dec 20, 2011 at 00:18, Julian Calaby <julian.calaby@gmail.com> wrote:
> So, as for actual code and data and stuff:
>
> The advice I was given when I was starting to write a driver (no
> source remains, it never got to the point where it did anything
> useful) was to start a new mac80211 driver from scratch as this
> hardware is significantly different from the "Libertas" devices as
> used in some mobile devices and the OLPC computers. Another approach
> would be to update the official driver to a newer kernel and stick it
> into staging, then clean it into a mac80211 driver and then push it
> out into the kernel tree proper. I was advised that if I needed any
> hardware info to look at the official driver. (see below)
>
> There is a blessed version of the firmware in the linux-firmware tree here:
>
> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=commitdiff;h=e694ee268684ec26af44a6b068203a5f44f6ed06
>
> The official Marvell driver, in a source tree here: - Note that this
> code only works on this exact kernel version and will need some
> significant work to run with any other kernel version.
>
> http://git.infradead.org/users/dwmw2/marvell-db64660-2.6.12.6.git
>
> And something approximating a partial driver here:
>
> http://git.infradead.org/mrv8k-2.6.git
>
> Also, the hardware is probably also significantly different to the
> "TopDog" devices, so using their driver as a base is probably a bad
> idea. They have an official driver in the source tree here:
>
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=drivers/net/wireless/mwl8k.c;h=995695c28d5c8d66c9999126e9203392428c24c2;hb=HEAD
> )

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
