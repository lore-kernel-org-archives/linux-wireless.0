Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:36699 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab0AMXj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 18:39:58 -0500
Received: by ewy1 with SMTP id 1so231341ewy.28
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2010 15:39:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b170af451001121451p73941b5ema0fb9be8685335ae@mail.gmail.com>
References: <op.u6fp5shd9lhzdc@linux-g0th.site>
	 <201001122310.21654.mb@bu3sch.de>
	 <b170af451001121451p73941b5ema0fb9be8685335ae@mail.gmail.com>
Date: Thu, 14 Jan 2010 00:39:54 +0100
Message-ID: <b170af451001131539p3974307fv8aad39a4ec71de9a@mail.gmail.com>
Subject: Re: [PATCH 1/3] b43: N-PHY: add b43_nphy_rx_iq_est and
	b43_nphy_tx_iq_workaround
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: bcm43xx-dev@lists.berlios.de,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 12 stycznia 2010 23:51 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> 2010/1/12 Michael Buesch <mb@bu3sch.de>:
>> On Tuesday 12 January 2010 20:38:07 Rafał Miłecki wrote:
>>>   struct nphy_txgains { u16 txgm[2]; u16 pga[2]; u16 pad[2]; u16 ipa[2]; };
>>> +struct nphy_iq_est { s32 iq0_prod; u32 i0_pwr; u32 q0_pwr; s32 iq1_prod;
>>> +                     u32 i1_pwr; u32 q1_pwr; };
>>
>> So it seems I didn't notice this earlier, but this violates kernel coding style.
>> Please do a separate patch that converts all structs from
>> struct foo { a; b; c; };
>> to
>> struct foo {
>>        a;
>>        b;
>>        c;
>> };
>
> OK, will do.

I'll use separated patch to correct old wrong-styled definitions. No
reason to use wrong style when adding new struct with this patch.

-- 
Rafał
