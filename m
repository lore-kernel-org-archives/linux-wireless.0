Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.inmail.at ([217.198.113.92]:56807 "EHLO smtp.inmail24.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbXKYKHg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 05:07:36 -0500
From: Majo <virec@inmail.sk>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: AR5006X on Fijitsu-Siemens Lifebook E8410 - not work
Date: Sun, 25 Nov 2007 11:07:30 +0100
Cc: linux-wireless@vger.kernel.org
References: <200711222310.01165.virec@inmail.sk> <40f31dec0711221538i503119b7hdeffbbde50629a6c@mail.gmail.com>
In-Reply-To: <40f31dec0711221538i503119b7hdeffbbde50629a6c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ilUSHtw2QRegEwZ"
Message-Id: <200711251107.30119.virec@inmail.sk> (sfid-20071125_100740_265095_17BC3B47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_ilUSHtw2QRegEwZ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

HI,

here are some Traces.

I dowloadet hte new snv from:

svn co http://svn.madwifi.org/madwifi/branches/madwifi-trace

make

sudo make install

Then i run the trase script from

svn co http://svn.madwifi.org/tools/trace

The Result is in Attachement.

I hope this can help you.

Majo



D=C5=88a Pi 23. November 2007 00:38 Nick Kossifidis nap=C3=ADsal:
> 2007/11/23, Majo <virec@inmail.sk>:
> > Hi,
> >
> > ath5sudo k don't work with my Notebook Wifi Card
> >
> > sudo lspci -v
> >
> > 14:00.0 Ethernet controller: Atheros Communications, Inc. AR5006EG 802.=
11
> > b/g Wireless PCI Express Adapter (rev 01)
>
> This is a 2424 pci-express card, we don't support this chip yet ;-(
>
> (damn i thought that was only the pci express version of 5414 that we
> just fixed, seems there's more to do)
>
> >   Subsystem: Atheros Communications, Inc. Unknown device 3067
> >   Flags: fast devsel, IRQ 19
> >   Memory at fe200000 (64-bit, non-prefetchable) [size=3D64K]
> >   Capabilities: [40] Power Management version 2
> >   Capabilities: [50] Message Signalled Interrupts: Mask- 64bit-
> > Queue=3D0/0
> > Enable-
> >   Capabilities: [60] Express Legacy Endpoint IRQ 0
> >   Capabilities: [90] MSI-X: Enable- Mask- TabSize=3D1
> >
> > - in Windows XP is detected as AR5006X
> >
> > dmesg
> >
> > [ 1276.969782] ACPI: PCI Interrupt 0000:14:00.0[A] -> GSI 19 (level, lo=
w)
> > -> IRQ
> > 19
> > [ 1276.969811] PCI: Setting latency timer of device 0000:14:00.0 to 64
> > [ 1277.982089] ath5k_hw_nic_wakeup: failed to resume the MAC Chip
>
> Hmm it seems that 5424/2424 and later chips have a different reset
> sequence we are not aware of. We 'll need traces to make it work, if
> you have some time plz take a look here ->
> http://madwifi.org/wiki/DevDocs/MadwifiTrace (the testbed stuff would
> really help)
>
>
> Thanx for the feedback ;-)

----------=0D=0A
AKCIOVA PONUKA - Zoner Photo Studio + digitalna klucenka. Viacej na http://=
www.zps9.sk/=0D=0A
=0D=0A

--Boundary-00=_ilUSHtw2QRegEwZ
Content-Type: application/x-tgz;
  name="-mad-trace-all-modes.tgz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="-mad-trace-all-modes.tgz"

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
NyGEEEIIIYQQQgghhLwp/wGhwBmFALgBAA==

--Boundary-00=_ilUSHtw2QRegEwZ--
