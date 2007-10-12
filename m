Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48959 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758911AbXJLG76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 02:59:58 -0400
Message-ID: <470F1B6B.10600@trash.net> (sfid-20071012_080016_569872_86DA5495)
Date: Fri, 12 Oct 2007 08:59:55 +0200
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: Frank de Lange <lkml-f@unternet.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [Oops] EIP is at ath5k_hw_reset+0x391/0xc82 [ath5k] (2.6.23,
 latest wireless git)
References: <20071011230030.GA6725@unternet.org> <470EFD24.7020206@trash.net> <40f31dec0710112348s79d652c9j6d6f9701a641a24f@mail.gmail.com>
In-Reply-To: <40f31dec0710112348s79d652c9j6d6f9701a641a24f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis wrote:
> Can you plz run ath_info tool found in madwifi/tools directory and
> post here the output ??
>   
# ./ath_info 0xc0210000
 -==Device Information==-
MAC Version:  5212 (0x50)
MAC Revision: 5213A(0x59)
PHY Revision: 5110 (0x0)
PHY Revision: 5110 (0x0)
 -==EEPROM Information==-
EEPROM Version:     4.8
EEPROM Size:        16K
Regulatory Domain:  0x60
 -==== Capabilities ====-
|  802.11a Support: no   |
|  802.11b Support: yes  |
|  802.11g Support: yes  |
|  RFKill  Support: yes  |
|  32KHz   Crystal: yes  |
 ========================
GPIO registers: CR 00000000 DO 00000000 DI 00000005

