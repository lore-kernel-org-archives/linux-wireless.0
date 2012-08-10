Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40333 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067Ab2HJJcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 05:32:10 -0400
Received: by weyx8 with SMTP id x8so868578wey.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 02:32:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5024CE29.5030500@broadcom.com>
References: <1344544690-11280-1-git-send-email-zajec5@gmail.com>
	<5024CE29.5030500@broadcom.com>
Date: Fri, 10 Aug 2012 11:32:08 +0200
Message-ID: <CACna6rzxb4jtFWOQcRvPxPE0KhTXP5P8fckaN-KaZMCyvq0Lhw@mail.gmail.com> (sfid-20120810_113214_625242_AD0BE49A)
Subject: Re: [PATCH wireless?] bcma: keep info about parallel flash presentence
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/8/10 Arend van Spriel <arend@broadcom.com>:
> On 08/09/2012 10:38 PM, Rafał Miłecki wrote:
>> This allows drivers to access flash conditionally and stop crashing some
>> devices.
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>> John: I suggest taking it for wirelesss, AKA fix
>
> Maybe you could mentioned devices and/or drivers crashes without this patch?

Yes, sure! The problematic one for me is arch/mips/bcm47xx/nvram.c.
Right now it assumes every BCMA board has pflash. I'll submit fix for
mips tree when this patch hits it.

-- 
Rafał
