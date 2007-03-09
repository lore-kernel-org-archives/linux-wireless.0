Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:16503 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965257AbXCICYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 21:24:13 -0500
Received: by nf-out-0910.google.com with SMTP id o25so881828nfa
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2007 18:24:12 -0800 (PST)
Message-ID: <1197ff4c0703081824p6ebf504fs6587b024fbd3733d@mail.gmail.com>
Date: Fri, 9 Mar 2007 10:24:10 +0800
From: "Yanbo Li" <dreamfly281@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: Problem with USB1.1 Host cores with the mb tree for bcm43xx_mac80211
Cc: "Larry Finger" <larry.finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	"Broadcom Linux" <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <200703081418.40809.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <45EF2015.8000802@lwfinger.net> <45EF4305.5060606@lwfinger.net>
	 <1197ff4c0703072356s575058e3h50c6104ec7609ff4@mail.gmail.com>
	 <200703081418.40809.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/8/07, Michael Buesch <mb@bu3sch.de> wrote:
> On Thursday 08 March 2007 08:56, Yanbo Li wrote:
> > It seemed my 4311 works without key
> > authrized.
>
> Eh, what?
>
> --
> Greetings Michael.
>
Sorry for my poor english, I mean the card work with "iwconfig eth1
key off".(eth1 is
the wireless card) This is my card info:

0c:00.0 0280: 14e4:4311 (rev 01)
        Subsystem: 1028:0007
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at dfdfc000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-
        Capabilities: [58] Message Signalled Interrupts: 64bit-
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Express Legacy Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
                Device: Latency L0s <4us, L1 unlimited
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
                Link: Latency L0s <4us, L1 <64us
                Link: ASPM L0s Enabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [13c] Virtual Channel

BR
lyb
