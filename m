Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from onstation.org ([52.200.56.107]:39572 "EHLO onstation.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751215AbdFFAR1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 20:17:27 -0400
Date: Mon, 5 Jun 2017 20:07:40 -0400
From: Brian Masney <masneyb@onstation.org>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        driverdev-devel@linuxdriverproject.org,
        linux-wireless@vger.kernel.org, kernelnewbies@kernelnewbies.org
Subject: Re: ks7010 firmware upload fail
Message-ID: <20170606000740.GA5645@3160d2e63219> (sfid-20170606_021731_722041_81FBB43A)
References: <20170605025637.GA23011@eros>
 <20170605072212.GB1495@katana>
 <20170605102444.GA31446@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170605102444.GA31446@eros>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 05, 2017 at 08:24:44PM +1000, Tobin C. Harding wrote:
> On Mon, Jun 05, 2017 at 09:22:12AM +0200, Wolfram Sang wrote:
> > Tobin,
> > 
> > > My question is should I be digging further into the MMC code or be doing
> > > something else with the driver code?
> > 
> > So, you haven't found any branch that worked? No plain v4.9 or the
> > gen3-sdio branch from my tree?
> 
> I have not tried cloning your tree. I am using the Rasperry Pi kernel
> source
> 
> https://github.com/raspberrypi/linux
> 
> which is v4.9.29

Hi Tobin,

Here are some instructions on how to compile an upstream kernel for a
Raspberry Pi: http://elinux.org/RPi_Upstream_Kernel_Compilation.
It describes setting up u-boot as the boot loader instead of the
boot loader that the Raspberry Pi kernel uses. One gotcha to be aware of
is that the config.txt file on the sd card won't be used.

Brian
