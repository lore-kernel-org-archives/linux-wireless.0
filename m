Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:47112 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbZH0PUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 11:20:07 -0400
Received: by fxm17 with SMTP id 17so996614fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 08:20:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A96A239.9000406@lwfinger.net>
References: <4A969572.7060807@gmail.com> <4A96A239.9000406@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 27 Aug 2009 17:19:48 +0200
Message-ID: <69e28c910908270819n65745ad3x7346ccb8c4850db9@mail.gmail.com>
Subject: Re: [PATCH] b43: Enable LP-PHY support by default and remove Kconfig
	warning
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/27 Larry Finger <Larry.Finger@lwfinger.net>:
> Gábor Stefanik wrote:
>> The most common LP-PHY device, BCM4312, is now fully functional.
>> So, no need to say "probably won't work for you" anymore.
>> It's also not "for debuggers and developers only", as it is
>> perfectly usable for end-users now (at least for BCM4312).
>>
>> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
>> ---
>> This replaces the "remove scary message" patch.
>>
>> drivers/net/wireless/b43/Kconfig |    4 +---
>> 1 files changed, 1 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/Kconfig
>> b/drivers/net/wireless/b43/Kconfig
>> index 237b1aa..2af3b35 100644
>> --- a/drivers/net/wireless/b43/Kconfig
>> +++ b/drivers/net/wireless/b43/Kconfig
>> -82,15 +82,13 @@ config B43_NPHY
> ===
>
> My copy of this patch is missing the @@ here. Is that true for everyone?
>
> Larry
>

Ah... the joy of Pastebin.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
