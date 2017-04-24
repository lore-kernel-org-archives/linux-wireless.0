Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53736 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1165766AbdDXGuj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 02:50:39 -0400
Message-ID: <1493016631.31741.139.camel@coelho.fi> (sfid-20170424_085043_207619_98CC93D9)
From: Luca Coelho <luca@coelho.fi>
To: Andi Kleen <andi@firstfloor.org>, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org
Date: Mon, 24 Apr 2017 09:50:31 +0300
In-Reply-To: <20170424005400.GK22592@two.firstfloor.org>
References: <20170424005400.GK22592@two.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: 4.11-rc* iwlwifi instable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2017-04-23 at 17:54 -0700, Andi Kleen wrote:
> Hi,

Hi Andi,


> Since I updated my laptop to 4.11-rc* the wireless is fairly instable
> (I think it was already less stable with 4.10 than with 4.8, but no
> clear data) 
> 
> For example it locked up (no more wireless) with a warn on while connecting
> and actually needed a reboot to recover (reloading modules was not
> enough)
> 
> Any fixes/workarounds?

It seems that you are using an old firmware version:

> [70585.074356] iwlwifi 0000:03:00.0: Loaded firmware version: 21.302800.0

We have already published version -27 for 4.11 and you're still using
version -21.  You can get the latest version from here:

https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/iwlwifi-7265D-27.ucode

We have loads of fixes and improvements in this new version.  And
hopefully it will make your problems go away. ;)

Please try it and let me know how it goes.

--
Cheers,
Luca.
