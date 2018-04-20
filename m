Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:36680 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751258AbeDTGDz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 02:03:55 -0400
Received: by mail-it0-f44.google.com with SMTP id e20-v6so1222069itc.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2018 23:03:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6e4b5e53-0a8d-978c-5cfe-f498c8b15c1a@gmail.com>
References: <6e4b5e53-0a8d-978c-5cfe-f498c8b15c1a@gmail.com>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Fri, 20 Apr 2018 09:03:54 +0300
Message-ID: <CANUX_P19ja=XLMs8Vvii1yMvCNAvPnMh7hs=H92M5QRJnJjRfg@mail.gmail.com> (sfid-20180420_080359_872279_BDFC7857)
Subject: Re: Simultaneous 2.4 GHz WiFi and Bluetooth issue on Intel Dual Band
 Wireless-AC 8260
To: Nathan Schulte <nmschulte@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


On Thu, Apr 19, 2018 at 11:46 PM, Nathan Schulte <nmschulte@gmail.com> wrote:
> Hi!
>

[...]

>
> Specifically, when testing with Debian Sid, I am unable to connect to
> 2.4 GHz WiFi and Bluetooth at the same time.  I can successfully use
> both independently, and 5 GHz WiFi and Bluetooth works fine.  It's been
> a number of months, but I believe simultaneous 2.4 GHz and Bluetooth
> worked fine in the past, and has slowly degraded.
>
> Under Windows 10, the hardware appears to work without issue.
> Additionally, I believe I managed to warm-reboot from Windows 10 to
> Linux (with Bluetooth connected), and was able to continue using the
> same 2.4 GHz WiFi and Bluetooth audio sink without issue.

This was reported in the past. Please make sure you have the latest BT
firmware files.
Ubuntu may not be shipping the newest BT firmware files. You can find them here:

https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git

Specifically, I can see that the BT firmware files were updated not long ago:
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/?id=9cb49be0eecf1de2c020e9de235a4fb5fd6665d7

Then you'll need a cold reboot.

>
> When blueman-manager isn't hanging (it tends to do that a lot in this
> situation), I am sometimes able to connect to 2.4 GHz WiFi and Bluetooth
> device for a short while before the Bluetooth stack disconnects the
> device.  Usually this requires removing and re-pairing the device.

Regardless of the BT firmware version thing which is a pure Intel
problem, I have heard
about problems in the BT stack itself but I can't help about this.
