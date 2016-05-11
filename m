Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbcEKCkX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 22:40:23 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Fisher Grubb <fisher.grubb@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Realtek USB WiFi rtl8192eu
References: <d6e308b0-5deb-e792-5991-5afc46aa7420@gmail.com>
	<e7b07631-da96-51c0-5960-ea5ed9d1d94f@gmail.com>
	<CAD4Xxq_WPVxU8h3+KyxdgztchYyzkW7GOQ8iCOf4uKMQ_X-CMg@mail.gmail.com>
	<wrfj1t59k56e.fsf@redhat.com>
	<CAD4Xxq8kEf6RJe=LD=uikSeC29RHO--ain0RhDL6976P2Vq=Xw@mail.gmail.com>
Date: Tue, 10 May 2016 22:40:21 -0400
In-Reply-To: <CAD4Xxq8kEf6RJe=LD=uikSeC29RHO--ain0RhDL6976P2Vq=Xw@mail.gmail.com>
	(Fisher Grubb's message of "Wed, 11 May 2016 11:32:12 +1000")
Message-ID: <wrfjbn4diaga.fsf@redhat.com> (sfid-20160511_044032_265537_9BA4FD27)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fisher Grubb <fisher.grubb@gmail.com> writes:
> Hi Jes,
>
> Thanks for the info.
>
> Ok, so I assume I just Google how to bring/compile a newer
> "unreleased" driver into a previous kernel version.
>
> Do I just need my current kernel's headers and typical GCC build toolchain?
>
> This is for Debian 7.9 on the ARM based BeagleBone Black board (Texas
> Instruments Sitara AM3358 CPU), which I uses kernel v3.8.13-bone79.
>
> I'm asking in case there's a big difference between kernel 3 to 4 for
> this type of driver to be compiled.
>
> I'm pretty sure certain kernel customisations were added by Robert
> Nelson for this board (I think he is quite involved with
> porting/fixing stuff for this board and the raspberry pi) , so I don't
> know how easy it would be for me to use a version 4 kernel.

Bringing back the driver into an older kernel is an open question. No
idea if that will work or not. Also note that ARM support is very
lightly tested and I do not believe anyone tested rtl8192eu support with
ARM.

Note that the driver currently does not support MESH and AP mode.

Jes
