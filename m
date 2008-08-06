Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([87.79.32.166]:2591 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYHFVQT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 17:16:19 -0400
Message-ID: <489A149A.8030401@wpkg.org> (sfid-20080806_231622_796408_2A8611B0)
Date: Wed, 06 Aug 2008 23:16:10 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Subject: Re: kernel panic on p54pci insertion on mipsel
References: <4898B018.5050202@wpkg.org> <1218053763.23048.67.camel@johannes.berg> <489A0970.9030104@wpkg.org> <200808062250.49495.chunkeey@web.de>
In-Reply-To: <200808062250.49495.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr schrieb:

(...)

>> Code;  c0071828 <END_OF_CODE+3fd7aa58/????>
>> 00000000 <_PC>:
>> Code;  c0071828 <END_OF_CODE+3fd7aa58/????>
>>    0:   8ca40150  lw      a0,336(a1)
>> Code;  c007182c <END_OF_CODE+3fd7aa5c/????>
>>    4:   24020001  li      v0,1
>> Code;  c0071830 <END_OF_CODE+3fd7aa60/????>
>>    8:   afa20010  sw      v0,16(sp)
>> Code;  c0071834 <END_OF_CODE+3fd7aa64/????>   <=====
>>    c:   8c820078  lw      v0,120(a0)   <=====
>> Code;  c0071838 <END_OF_CODE+3fd7aa68/????>
>>   10:   00a08021  move    s0,a1
>> Code;  c007183c <END_OF_CODE+3fd7aa6c/????>
>>   14:   30420200  andi    v0,v0,0x200
>> Code;  c0071840 <END_OF_CODE+3fd7aa70/????>
>>   18:   1440009f  bnez    v0,298 <_PC+0x298>
>> Code;  c0071844 <END_OF_CODE+3fd7aa74/????>
>>   1c:   8cb10160  lw      s1,352(a1)
>> Code;  c0071848 <END_OF_CODE+3fd7aa78/????>
>>   20:   8c820010  lw      v0,16(a0)
>>
>> Kernel panic - not syncing: Fatal exception in interrupt
>>
> 
> Ouch?! Are you sure your hardware isn't damaged?
> Can you please try another wifi card in your mips,
> or "test" the wifi card in a x86?

I took it from a IXP (arm) router, where it worked.

I'll verify if it works on x86, though.


-- 
Tomasz Chmielewski
http://wpkg.org
