Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36456 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952Ab2HJJcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 05:32:55 -0400
Received: by wibhr14 with SMTP id hr14so1191014wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 02:32:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rzxb4jtFWOQcRvPxPE0KhTXP5P8fckaN-KaZMCyvq0Lhw@mail.gmail.com>
References: <1344544690-11280-1-git-send-email-zajec5@gmail.com>
	<5024CE29.5030500@broadcom.com>
	<CACna6rzxb4jtFWOQcRvPxPE0KhTXP5P8fckaN-KaZMCyvq0Lhw@mail.gmail.com>
Date: Fri, 10 Aug 2012 11:32:54 +0200
Message-ID: <CACna6rw=-PV0w4T9S=3uGrORAUp_BbGHbg9QHRWYuRT9GwpM8A@mail.gmail.com> (sfid-20120810_113258_394535_11E6ACC7)
Subject: Re: [PATCH wireless?] bcma: keep info about parallel flash presentence
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/8/10 Rafał Miłecki <zajec5@gmail.com>:
> 2012/8/10 Arend van Spriel <arend@broadcom.com>:
>> On 08/09/2012 10:38 PM, Rafał Miłecki wrote:
>>> This allows drivers to access flash conditionally and stop crashing some
>>> devices.
>>>
>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
>>> ---
>>> John: I suggest taking it for wirelesss, AKA fix
>>
>> Maybe you could mentioned devices and/or drivers crashes without this patch?
>
> Yes, sure! The problematic one for me is arch/mips/bcm47xx/nvram.c.
> Right now it assumes every BCMA board has pflash. I'll submit fix for
> mips tree when this patch hits it.

Ah, and device. My Netgear WNDR4500 has serial flash and NAND flash.
It doesn't have parallel one, so this code crashes my device.

-- 
Rafał
