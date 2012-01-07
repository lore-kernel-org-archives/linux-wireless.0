Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41058 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759467Ab2AGIe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 03:34:28 -0500
Received: by werm1 with SMTP id m1so1618988wer.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jan 2012 00:34:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F072EB2.9050306@lwfinger.net>
References: <4F070CF4.5030708@gmail.com>
	<4F07186D.7020708@lwfinger.net>
	<16960B23-D3DA-4104-8F38-662DFA8D0A3E@gmail.com>
	<4F072EB2.9050306@lwfinger.net>
Date: Sat, 7 Jan 2012 09:34:27 +0100
Message-ID: <CACna6rzLjmCsVU8EzrO=_eM41K0wM+ukvH8TEJFEoH7R74wxLA@mail.gmail.com> (sfid-20120107_093439_111717_E5692E61)
Subject: Re: how to uninstall the b43 and reinstall
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: lina <lina.lastname@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/1/6 Larry Finger <Larry.Finger@lwfinger.net>:
> On 01/06/2012 10:58 AM, lina wrote:
>>
>> Yes, did remove old kernel also removed my old built compact-wireless?
>> Sorry im not in front of computer. Just check email by phone.
>
>
> Kernel modules must be built for the kernel you are using. Yes, switching
> from 3.2-rc6 to 3.2 removed compat-wireless. Reinstall it under kernel v3.2,
> and your 4313 will work again.

3.2-rc6 is enough actually. It's just matter of enabling HT-PHY support:
B43_PHY_HT

-- 
Rafał
