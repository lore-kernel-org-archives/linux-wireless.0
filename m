Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:62268 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbYJEJCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 05:02:11 -0400
Received: by yw-out-2324.google.com with SMTP id 9so357727ywe.1
        for <linux-wireless@vger.kernel.org>; Sun, 05 Oct 2008 02:02:09 -0700 (PDT)
Message-ID: <43e72e890810050202x737a2230m351c8d11f32ff705@mail.gmail.com> (sfid-20081005_110220_559921_1D7623FE)
Date: Sun, 5 Oct 2008 02:02:09 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tim Gardner" <tim.gardner@canonical.com>,
	"Ben Collins" <bcollins@ubuntu.com>
Subject: Re: Let Ubuntu Installing your initrd by default when compiling a kernel
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890810041958t59985657iccde75c2c0a0b1aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890810041958t59985657iccde75c2c0a0b1aa@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 4, 2008 at 7:58 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> Upon a 'make install' on a kernel source directory I think
> distributions should automagically build your initrd for you. I use
> Ubuntu mainly on x86 and for those boxen I installed debianutils,
> which provides /sbin/installkernel. This is the path and filename to
> the "distribution" script which the kernel Makefiles will run when you
> type try to build the install target.
>
> Fedora for example builds your all this shiny stuff for you too. I've
> modified Debian's installkernel script to do this for Ubuntu. It'd be
> nice to see Ubuntu ship with this script and with the below patch
> applied. Mind you, Debian ships this script in debianutils. I haven't
> run debian in a while so not sure if debian uses the same format as
> you do for their initrd. If so then this can go upstream.
>
> Just a small itch I had to scratch as I just apt-get dist-upgraded and
> Ubuntu replaced my installkernel with the new one and it wasn't there.

BTW the fact that this went to linux-wireless was a complete goof :)
Don't know WTF happened. I blame e1000e for anything strange happening
lately.

  Luis
