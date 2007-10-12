Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from av9-2-sn2.hy.skanova.net ([81.228.8.180]:55413 "EHLO
	av9-2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759892AbXJLJHi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 05:07:38 -0400
Date: Fri, 12 Oct 2007 11:07:28 +0200
From: Frank de Lange <lkml-f@unternet.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>,
	Frank de Lange <lkml-f@unternet.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [Oops] EIP is at ath5k_hw_reset+0x391/0xc82 [ath5k] (2.6.23,
	latest wireless git)
Message-ID: <20071012090728.GA9037@unternet.org> (sfid-20071012_100800_198994_83335FBF)
References: <20071011230030.GA6725@unternet.org> <470EFD24.7020206@trash.net> <40f31dec0710112348s79d652c9j6d6f9701a641a24f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0710112348s79d652c9j6d6f9701a641a24f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 12, 2007 at 06:48:17AM +0000, Nick Kossifidis wrote:
> Can you plz run ath_info tool found in madwifi/tools directory and
> post here the output ???

#lspci -v

02:02.0 Ethernet controller: Atheros Communications, Inc. AR2413
802.11bg NIC (rev 01)
        Subsystem: Askey Computer Corp. Unknown device 7094
        Flags: bus master, medium devsel, latency 96, IRQ 11
        Memory at c0200000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [44] Power Management version 2

#ath_info 0xc0200000
 -==Device Information==-
MAC Version:  5213A(0x70)
MAC Revision: 5213A(0x78)
PHY Revision: 2112a(0x56)
 -==EEPROM Information==-
EEPROM Version:     5.2
EEPROM Size:        16K
Regulatory Domain:  0x64
 -==== Capabilities ====-
|  802.11a Support: no   |
|  802.11b Support: yes  |
|  802.11g Support: yes  |
|  RFKill  Support: yes  |
|  32KHz   Crystal: no   |
 ========================
GPIO registers: CR 00000000 DO 00000000 DI 00000017


Cheers//Frank

-- 
   WWWWW      ________________________
  ## o o\    /     Frank de Lange     \
  }#   \|   /                          \
   \ `--| _/     <Hacker for Hire>      \
    `---'  \       +46-734352015        /
            \    frank@unternet.org    /
             `------------------------'
  [ "Omnis enim res, quae dando non deficit, dum habetur
     et non datur, nondum habetur, quomodo habenda est."  ]
