Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:57805 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdLDPzA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 10:55:00 -0500
Date: Mon, 4 Dec 2017 16:54:58 +0100
From: Mylene JOSSERAND <mylene.josserand@free-electrons.com>
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: Wifi RTL8723bu driver test: failed to scan
Message-ID: <20171204165458.0bf87509@dell-desktop.home> (sfid-20171204_165508_295691_2E35AAA8)
In-Reply-To: <75669dd0-1f25-fc7e-4a4d-a5549aeeb2cf@gmail.com>
References: <20171122105116.57c3c000@dell-desktop.home>
        <75669dd0-1f25-fc7e-4a4d-a5549aeeb2cf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Le Tue, 28 Nov 2017 11:14:10 -0500,
Jes Sorensen <jes.sorensen@gmail.com> a écrit :

> On 11/22/2017 04:51 AM, Mylene JOSSERAND wrote:
> > Hello Jes Sorensen,
> > 
> > I am currently testing a LM811 Wifi/BT USB dongle [1] on a Sinlinx
> > SinA33 Allwinner SoC board [2]. I saw that I should use the realtek
> > driver RTL8723BU for this USB dongle.
> > 
> > Currently, I am only testing the Wifi and the mainline driver
> > (kernel 4.14-rc7) does not seem to work. At least, the scanning
> > does not output anything.
> > 
> > I tested the driver recommended by LM Technologies [3] and it works
> > fine (scan, connect and ping are ok). Before investigating on the
> > differences between these two drivers, do you have any idea about
> > this issue?
> > 
> > Here are the commands and output I got with mainline's driver:  
> 
> I have not looked at the driver these LM Technologies people are
> referring to, but I am guessing it's the vendor code.

Yes, it is.

> 
> 8723bu is a little dicey because it has BT in the chip and if you
> enable that the two drivers need to interact, which rtl8xxxu
> currently doesn't know about. Check your dmesg output to make sure
> you don't have some BT thing loaded hijacking the chip.

Okay, I was also testing the BT so maybe, it was the case. I will
have a try without any BT drivers.

Anyway, thank you for your help!

Best regards,

-- 
Mylène Josserand, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
