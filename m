Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:60062 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXKLQY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 11:24:29 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1214236rvb
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2007 08:24:28 -0800 (PST)
Message-ID: <43e72e890711120824h2b893850i25f831ef7078a8fb@mail.gmail.com> (sfid-20071112_162432_240781_80FC597A)
Date: Mon, 12 Nov 2007 11:24:28 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "maximilian attems" <max@stro.at>
Subject: Re: Intel PRO/Wireless 3945ABG mini-pci Card
Cc: "Markus Feldmann" <feldmann_markus@gmx.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071112160535.GG14432@baikonur.stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <fh9te0$n6g$1@ger.gmane.org>
	 <20071112160535.GG14432@baikonur.stro.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 12, 2007 11:05 AM, maximilian attems <max@stro.at> wrote:
> On Mon, Nov 12, 2007 at 05:01:13PM +0100, Markus Feldmann wrote:
> > Hi All,
> >
> > I want to buy a Intel(R) PRO/Wireless 3945ABG mini-pci Card for my Laptop.
> > I use Debian Etch as Operating System.
> >
> > My Questions,
> > Is there a driver in the 2.6.23 Kernel for this Card?
> > Or will there be a Driver in the Future in the Kernel integrated?
> > Or do i have to download and install the Driver by Hand?
> > If there is still a Driver in the Kernel 2.6.23, then is this Driver
> > stable?
>
> merged in latest linus,
> we backported an earlier version in prebuild 2.6.23 snapshots see
> trunk apt lines -> http://wiki.debian.org/DebianKernel

Also if you want to try the latest with your current kernel by only
compiling the drivers (not the entire kernel):

http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2

I haven't tested this on 2.6.23 yet though, if you do, please let me
know how it goes.

  Luis
