Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:47987 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbYIGLxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 07:53:38 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1150685wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 07 Sep 2008 04:53:37 -0700 (PDT)
Message-ID: <69e28c910809070453h7264f599hc829b9e1bebdf1f1@mail.gmail.com> (sfid-20080907_135342_680451_41543687)
Date: Sun, 7 Sep 2008 13:53:37 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: Broadcom Corporation BCM4310 USB Controller
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0809071146590.3981@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <Pine.LNX.4.64.0809071146590.3981@axis700.grange>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 7, 2008 at 12:33 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi
>
> The above adapter is installed in my ACER Extensa 5220, googling around I
> found various references to this chip, the main resume seems to be "works
> only with ndiswrapper." Is it true and if it is ATM, is it going to
> change?:-) Any work in progress or plans to support it natively? lspci -vv
> output is at http://home.arcor.de/g.liakhovetski/extensa5220/.
>
> Tried brutally adding the PCI ID to the ssb driver and ssb ID to the b43
> driver. Here's the result:
>
> ACPI: PCI interrupt for device 0000:04:00.0 disabled
> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> PCI: Setting latency timer of device 0000:04:00.0 to 64
> ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor 0x4243)
> ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F, vendor 0x4243)
> ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
> ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
> ssb: WARNING: Invalid SPROM CRC (corrupt SPROM)
> ssb: SPROM revision 255 detected.
> ssb: Unsupported SPROM revision 255 detected. Will extract v1
> ssb: Sonics Silicon Backplane found on PCI device 0000:04:00.0
> b43-phy1: Broadcom 4312 WLAN found
> b43-phy1 ERROR: FOUND UNSUPPORTED PHY (Analog 6, Type 5, Revision 1)
> b43: probe of ssb0:0 failed with error -95
> Broadcom 43xx driver loaded [ Features: P, Firmware-ID: FW13 ]
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer

This card (BCM4310/4312) is a new low-power (LP-PHY) card, which is
not yet supported. Work on this card is ongoing, but no official
timeframe exists. (Hopefully it will make 2.6.28 or .29.)

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
