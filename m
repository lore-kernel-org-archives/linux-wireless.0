Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50244 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752760AbdDJLOR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 07:14:17 -0400
Message-ID: <1491822841.31980.45.camel@coelho.fi> (sfid-20170410_131540_206125_52E80812)
From: Luca Coelho <luca@coelho.fi>
To: =?ISO-8859-1?Q?=22K=E4fer=2C?= "Marcel\"" <mk@djagoo.io>,
        linuxwifi@intel.com, linux-wireless@vger.kernel.org
Date: Mon, 10 Apr 2017 14:14:01 +0300
In-Reply-To: <212619248.282995.1491726087885.JavaMail.open-xchange@app09.ox.hosteurope.de>
References: <212619248.282995.1491726087885.JavaMail.open-xchange@app09.ox.hosteurope.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: iwlwifi crashing on X1 Carbon 5th Gen iwlwifi-8265 "Microcode
 SW error detected"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sun, 2017-04-09 at 10:21 +0200, 
> Hello,
> 
> on the new 5th Gen Lenovo X1 Carbon and Intel 8265 on a fresh Arch install
> iwlwifi keeps crashing the moment network is coming up. Happens on both
> core/linux-firmware 20170309.695f2d6-1 and aur/linux-firmware-iwlwifi-git.
> 
> After it's crashing it's impossible to rmmod iwlmvm and iwlwifi, all netctl and
> ip commands are hanging, sudo isn't working and even shutdown isn't working.
> Tried netctl and NetworkManager. Netctl sometimes work for a few minutes before
> it crashes, NetworkManager is chrashing after a few seconds.
> Someone reported a bug with Intel 7265D card wich looks exactly the same.
> https://bugs.archlinux.org/task/53317
> The firmware files for 8265 found in /lib/firmware are:
> - iwlwifi-8265-21.ucode
> - iwlwifi-8265-22.ucode
> - iwlwifi-8265-27.ucode
> 
> The dmesg output is attached to this mail as dmesg.txt

Please refer to this bug in bugzilla:

https://bugzilla.kernel.org/show_bug.cgi?id=193641

--
Cheers,
Luca.
