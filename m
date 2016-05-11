Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:34760 "EHLO
	mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbcEKBcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 21:32:13 -0400
Received: by mail-vk0-f65.google.com with SMTP id v68so3092244vka.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2016 18:32:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <wrfj1t59k56e.fsf@redhat.com>
References: <d6e308b0-5deb-e792-5991-5afc46aa7420@gmail.com>
	<e7b07631-da96-51c0-5960-ea5ed9d1d94f@gmail.com>
	<CAD4Xxq_WPVxU8h3+KyxdgztchYyzkW7GOQ8iCOf4uKMQ_X-CMg@mail.gmail.com>
	<wrfj1t59k56e.fsf@redhat.com>
Date: Wed, 11 May 2016 11:32:12 +1000
Message-ID: <CAD4Xxq8kEf6RJe=LD=uikSeC29RHO--ain0RhDL6976P2Vq=Xw@mail.gmail.com> (sfid-20160511_033217_437122_E4EAB924)
Subject: Re: Realtek USB WiFi rtl8192eu
From: Fisher Grubb <fisher.grubb@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jes,

Thanks for the info.

Ok, so I assume I just Google how to bring/compile a newer
"unreleased" driver into a previous kernel version.

Do I just need my current kernel's headers and typical GCC build toolchain?

This is for Debian 7.9 on the ARM based BeagleBone Black board (Texas
Instruments Sitara AM3358 CPU), which I uses kernel v3.8.13-bone79.

I'm asking in case there's a big difference between kernel 3 to 4 for
this type of driver to be compiled.

I'm pretty sure certain kernel customisations were added by Robert
Nelson for this board (I think he is quite involved with
porting/fixing stuff for this board and the raspberry pi) , so I don't
know how easy it would be for me to use a version 4 kernel.

Thanks,

Fisher

On 11 May 2016 06:51, "Jes Sorensen" <Jes.Sorensen@redhat.com> wrote:
>
> Fisher Grubb <fisher.grubb@gmail.com> writes:
> > Hi Xose,
> >
> > I'm not sure, I have the latest version of Ubuntu on my laptop and I
> > had to use the DKMS -2 deb file to get it working as no driver claimed
> > it.
> >
> > After Googeling (especially for the 0bda:818b USB device and vendor
> > ID), it seemed the driver supported most of Realtek's WiFi devices but
> > mine wasn't listed.
> >
> > From memory, I used this page mainly when I was first checking:
> > https://wiki.debian.org/rtl819x
> >
> > I didn't see any people in forums mentioning how they managed to get
> > this standard driver working, they all seemed to either have no luck
> > because code didn't compile, or link to source code that did compile.
> >
> > If that mainline driver does work, then I assume there could be some
> > USB vendor and device IDs that it doesn't cover.
> >
> > Here's the link for where I bought it:
> > http://www.ebay.com.au/itm/181860888357
>
> Patches to add rtl8192eu support was pulled into wireless-drivers-next
> recently and scheduled for the 4.7 kernel. It is not in Linus' tree
> yet. You should be able to try it out by either building Kalle's
> wireless-drivers-next or my rtl8xxxu-devel branch.
>
> The Realtek 8192EU driver you referenced is not scheduled to get pulled
> into the upstream Linux kernel.
>
> Cheers,
> Jes
