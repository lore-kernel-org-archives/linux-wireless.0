Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45546 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1G3Sji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 14:39:38 -0400
Received: by qyk9 with SMTP id 9so2674924qyk.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 11:39:37 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110730181433.50bd32db.ldarby@tuffmail.com>
References: <20110730181433.50bd32db.ldarby@tuffmail.com>
Date: Sat, 30 Jul 2011 20:39:37 +0200
Message-ID: <CA+icZUURFL1AgYZ=64zqgvU1DTjmp=22Qesp2pM86-OOyRjmVw@mail.gmail.com> (sfid-20110730_203940_503419_4ED965A7)
Subject: Re: I'm confused and angry
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Laurence Darby <ldarby@tuffmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, Jul 30, 2011 at 7:14 PM, Laurence Darby <ldarby@tuffmail.com> wrote:
>
> Is there an obvious list of consumer products (NOT chipsets) that
> hostapd supports that I'm missing?
>
> I want to make a wireless Access Point, using either a USB dongle, PCI
> card, or PCIE x1 card.  I have already got a DHCP server and NAT in
> both my desktop PC and router, I don't want to pay for an expensive
> external wireless router which would be a 3rd DHCP and NAT.
>
> None of the consumer devices' websites say which chipset they use, and none
> the chipset manufactures' sites say what consumer products use their
> chipset, so I can't just search for devices that support this.
>
> I've foolishly just bought a Netgear WNA1100, because it was "close
> enough" to a Netgear WNA1000, which possibly supports AP mode, but that
> wasn't available.
>

A different hardware-revision can mean that vendor has changed wifi-chip :-).
So, better ask before you buy new hardware.

> I thought it got away with it, because this page:
> http://linuxwireless.org/en/users/Drivers/ath9k_htc says that driver
> supports AP mode.
>

AFAICS, people on #linux-wireless dont recommend USB-devices as the
interface can be a bottleneck.

> I've upgraded to Linux 3.0 and installed the htc_9271.fw firmware, and
> the device shows up in /proc/net/dev, but now hostapd is giving me the
> errors:
>
> rfkill: Cannot open RFKILL control device
> Hardware does not support configured mode
> wlan0: IEEE 802.11 Hardware does not support configured mode (2)
> Could not select hw_mode and channel. (-2)
> wlan0: Unable to setup interface.
> rmdir[ctrl_interface]: No such file or directory
>

Please, send full dmesg, lspci/lsusb outputs, etc.
What software do you use to connect to AP from client?
Personally, I have no HostAP(d) in use, but interested people might
want to see its config files, the same for the kernel.

> Does this device and driver support AP mode or not?  If the driver
> doesn't, then the web page is wrong.
>
> If the driver does but the device doesn't, then the website should make
> that clear.
>

And of course, docs could be enhanced.
It's a wiki, feel free to join and correct.

> I'm not bothered at all if the WNA1100 was a waste of money, it's the
> amount of time I've wasted on this so far.
>

Maybe a business solution with an anual or longterm contract can help
(if money does not count).

> Please CC me on any responses, I'm not subscribed.
>

You can try to ask on IRC, try joining #linux-wireless (freenode) and
ask there (note, it's sometimes a very silent channel).
But please, be nice and polite :-).

- Sedat -

> Thanks,
> Laurence
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
