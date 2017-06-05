Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54485 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751373AbdFEKYt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 06:24:49 -0400
Date: Mon, 5 Jun 2017 20:24:44 +1000
From: "Tobin C. Harding" <me@tobin.cc>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-wireless@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org,
        kernelnewbies@kernelnewbies.org
Subject: Re: ks7010 firmware upload fail
Message-ID: <20170605102444.GA31446@eros> (sfid-20170605_122452_926366_7C89F92A)
References: <20170605025637.GA23011@eros>
 <20170605072212.GB1495@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170605072212.GB1495@katana>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 05, 2017 at 09:22:12AM +0200, Wolfram Sang wrote:
> Tobin,
> 
> > My question is should I be digging further into the MMC code or be doing
> > something else with the driver code?
> 
> So, you haven't found any branch that worked? No plain v4.9 or the
> gen3-sdio branch from my tree?

I have not tried cloning your tree. I am using the Rasperry Pi kernel
source

https://github.com/raspberrypi/linux

which is v4.9.29

I checked out the last commit you made to the mainline then cross
compiled the driver from within the Rpi tree, copied the module over
to the Pi and insmod'd it.

To debug I was making code changes on my desktop, re cross compiling
the module and scp'ing it over (then rmmod'ing and insmod'ing the new module).

I'll try using a vanilla 4.9 kernel, and if that fails I'll try cloning your tree.

Thanks for getting back to me.

Will report my progress.

thanks,
Tobin.
