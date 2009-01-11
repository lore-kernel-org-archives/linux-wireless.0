Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:50006 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZAKBV7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 20:21:59 -0500
Received: by rv-out-0506.google.com with SMTP id k40so9650871rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 10 Jan 2009 17:21:58 -0800 (PST)
Message-ID: <30c8a83c0901101721x3928086fmcad80aaa098765d2@mail.gmail.com> (sfid-20090111_022205_600464_A6E267F2)
Date: Sat, 10 Jan 2009 19:21:58 -0600
From: "Buran Ayuthia" <the.ayuthias@googlemail.com>
To: "Lorenzo Nava" <navalorenx@gmail.com>
Subject: Re: [b43] opensource firmware
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	"Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <AE7A4FD8-1728-4CE2-8CC7-DCE699C3B6C9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200901091129.22708.mb@bu3sch.de> <200901091149.28683.mb@bu3sch.de>
	 <9F70A0D3-6334-45FB-9DAF-263FE89C847E@ing.unibs.it>
	 <200901091206.09736.mb@bu3sch.de>
	 <AE7A4FD8-1728-4CE2-8CC7-DCE699C3B6C9@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have just tried out the firmware on my 4311 rev 01 using the 2.6.28
kernel and it works!  I am using an HP Pavilion dv6338se laptop.

Here is my lspci info:
03:00.0 Network controller [0280]: Broadcom Corporation BCM94311MCG
wlan mini-PCI [14e4:4311] (rev 01)
        Subsystem: Hewlett-Packard Company Device [103c:1363]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at b6000000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Express (v1) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<4us, L1 unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s,
Latency L0 <4us, L1 <64us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [13c] Virtual Channel <?>
        Kernel driver in use: b43-pci-bridge
        Kernel modules: wl, ssb

Please let me know if you need more information.  Also, are we to use
this mailing list or is there another place where this information
should be posted?

Buran Ayuthia

On Sat, Jan 10, 2009 at 11:37 AM, Lorenzo Nava <navalorenx@gmail.com> wrote:
> Hello everybody,
>
> today I tried OpenFWWF with kernel 2.6.28 on a Siemens wifi device
> with Broadcom 4306 chipset:
>
> BCM94306 802.11g (rev 03)
> PHY: Analog 2, Type 2, Revision 2
> Radio: Manuf 0x17F, Version 0x2050, Revision 2
>
> I did some tests and everything seems to work fine.
>
> I remember, once again, that OpenFWWF needs v480 initvals to work
> properly, and was tested on 2.6.27-rc5 kernel.
>
> During firmware development we used these devices
>
> Belkin PCMCIA 4306 card,
> Siemens PCI 4306 card.
> Belkin PCI 4306 card.
> ASUSTeK PCI 4318 card.
>
> and firmware seems to work fine. Everyone that is interested in
> testing OpenFWWF is welcome: please let us know if the firmware works
> correctly, and, if it doesn't, please report which kind of problems
> you had.
>
> Michael please let us know which kind of problem you had with your
> device.
>
> cheers
>
> Lorenzo Nava.
>
>
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>
