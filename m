Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:2401 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbXJQOLl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 10:11:41 -0400
Date: Wed, 17 Oct 2007 16:11:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ismail =?iso-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: iwl3945 doesn't work
Message-ID: <20071017141111.GM5043@kernel.dk> (sfid-20071017_151143_033385_B319B1C4)
References: <20071017135452.GJ5043@kernel.dk> <200710171708.48654.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200710171708.48654.ismail@pardus.org.tr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 17 2007, Ismail D=F6nmez wrote:
> Wednesday 17 October 2007 Tarihinde 16:54:53 yazm????t??:
> > Hi,
> >
> > Seeing that iwl3945 is now merged, I decided to switch my x60 to us=
e
> > that instead of ipw3945. That would leave me with zero kernel
> > dependencies.
> >
> > Unfortunately it doesn't work. Loading the module reveals the devic=
e:
> >
> > iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver=
 for
> > Linux, 1.1.17ks
> > iwl3945: Copyright(c) 2003-2007 Intel Corporation
> > ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 2=
1
> > PCI: Setting latency timer of device 0000:03:00.0 to 64
> > iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
> > iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
> > phy0: Selected rate control algorithm 'iwl-3945-rs'
> >
> > # iwconfig wlan0
> > wlan0     IEEE 802.11g  ESSID:"xxxxxxxxxxxxxx"
> >           Mode:Managed  Channel:0  Access Point: Not-Associated
> >           Tx-Power=3D0 dBm
> >           Retry min limit:7   RTS thr:off   Fragment thr=3D2346 B
> >           Encryption key:XXXX-XXXX-XX
> >           Link Quality:0  Signal level:0  Noise level:0
> >           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
> >           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> >
> > and iwconfig sees it, essid/enc settings are fine, but I don't get =
a
> > link.
>=20
> Same issue here, try iwlist wlan0 scan first and then it should work.

Huh indeed, now it links fine! Thanks for the hint. Would be nice to
have fixed, though :-)

--=20
Jens Axboe

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
