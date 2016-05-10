Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbcEJUvW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:51:22 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Fisher Grubb <fisher.grubb@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Realtek USB WiFi rtl8192eu
References: <d6e308b0-5deb-e792-5991-5afc46aa7420@gmail.com>
	<e7b07631-da96-51c0-5960-ea5ed9d1d94f@gmail.com>
	<CAD4Xxq_WPVxU8h3+KyxdgztchYyzkW7GOQ8iCOf4uKMQ_X-CMg@mail.gmail.com>
Date: Tue, 10 May 2016 16:51:21 -0400
In-Reply-To: <CAD4Xxq_WPVxU8h3+KyxdgztchYyzkW7GOQ8iCOf4uKMQ_X-CMg@mail.gmail.com>
	(Fisher Grubb's message of "Tue, 10 May 2016 23:16:36 +1000")
Message-ID: <wrfj1t59k56e.fsf@redhat.com> (sfid-20160510_225127_505131_0F3B4D8E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fisher Grubb <fisher.grubb@gmail.com> writes:
> Hi Xose,
>
> I'm not sure, I have the latest version of Ubuntu on my laptop and I
> had to use the DKMS -2 deb file to get it working as no driver claimed
> it.
>
> After Googeling (especially for the 0bda:818b USB device and vendor
> ID), it seemed the driver supported most of Realtek's WiFi devices but
> mine wasn't listed.
>
> From memory, I used this page mainly when I was first checking:
> https://wiki.debian.org/rtl819x
>
> I didn't see any people in forums mentioning how they managed to get
> this standard driver working, they all seemed to either have no luck
> because code didn't compile, or link to source code that did compile.
>
> If that mainline driver does work, then I assume there could be some
> USB vendor and device IDs that it doesn't cover.
>
> Here's the link for where I bought it:
> http://www.ebay.com.au/itm/181860888357

Patches to add rtl8192eu support was pulled into wireless-drivers-next
recently and scheduled for the 4.7 kernel. It is not in Linus' tree
yet. You should be able to try it out by either building Kalle's
wireless-drivers-next or my rtl8xxxu-devel branch.

The Realtek 8192EU driver you referenced is not scheduled to get pulled
into the upstream Linux kernel.

Cheers,
Jes
