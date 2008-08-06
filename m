Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:48580 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbYHFUsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 16:48:04 -0400
From: Chr <chunkeey@web.de>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: kernel panic on p54pci insertion on mipsel
Date: Wed, 6 Aug 2008 22:50:49 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>
References: <4898B018.5050202@wpkg.org> <1218053763.23048.67.camel@johannes.berg> <489A0970.9030104@wpkg.org>
In-Reply-To: <489A0970.9030104@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808062250.49495.chunkeey@web.de> (sfid-20080806_224809_552562_C0DCD4B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 06 August 2008 22:28:32 Tomasz Chmielewski wrote:
>
> >>RA;  8004cc30 <handle_IRQ_event+64/d4>
> >>$12; 802e0000 <invalid_pte_table+0/1000>
> >>$14; 802e4588 <per_cpu__runqueues+30/410>
> >>$31; 8004cc30 <handle_IRQ_event+64/d4>
> >>
> >>PC;  c0071834 <END_OF_CODE+3fd7aa64/????>   <=====
>
> Trace; 8018405c <usb_hcd_irq+68/150>
> Trace; 8001d2bc <try_to_wake_up+78/c8>
> Trace; 8004cc30 <handle_IRQ_event+64/d4>
> Trace; 8004e0dc <handle_percpu_irq+54/ac>
> Trace; 80002ca4 <ret_from_irq+0/4>
> Trace; 8001c310 <__wake_up_common+54/bc>
> Trace; 80001e54 <plat_irq_dispatch+1ac/1d8>
> Trace; 80002ca4 <ret_from_irq+0/4>
> Trace; 80125850 <vscnprintf+14/30>
> Trace; c0070c00 <END_OF_CODE+3fd79e30/????>
> Trace; c0070c98 <END_OF_CODE+3fd79ec8/????>
> Trace; c007118c <END_OF_CODE+3fd7a3bc/????>
>
> Code;  c0071828 <END_OF_CODE+3fd7aa58/????>
> 00000000 <_PC>:
> Code;  c0071828 <END_OF_CODE+3fd7aa58/????>
>    0:   8ca40150  lw      a0,336(a1)
> Code;  c007182c <END_OF_CODE+3fd7aa5c/????>
>    4:   24020001  li      v0,1
> Code;  c0071830 <END_OF_CODE+3fd7aa60/????>
>    8:   afa20010  sw      v0,16(sp)
> Code;  c0071834 <END_OF_CODE+3fd7aa64/????>   <=====
>    c:   8c820078  lw      v0,120(a0)   <=====
> Code;  c0071838 <END_OF_CODE+3fd7aa68/????>
>   10:   00a08021  move    s0,a1
> Code;  c007183c <END_OF_CODE+3fd7aa6c/????>
>   14:   30420200  andi    v0,v0,0x200
> Code;  c0071840 <END_OF_CODE+3fd7aa70/????>
>   18:   1440009f  bnez    v0,298 <_PC+0x298>
> Code;  c0071844 <END_OF_CODE+3fd7aa74/????>
>   1c:   8cb10160  lw      s1,352(a1)
> Code;  c0071848 <END_OF_CODE+3fd7aa78/????>
>   20:   8c820010  lw      v0,16(a0)
>
> Kernel panic - not syncing: Fatal exception in interrupt
>

Ouch?! Are you sure your hardware isn't damaged?
Can you please try another wifi card in your mips,
or "test" the wifi card in a x86?

Regards,
	Chr
