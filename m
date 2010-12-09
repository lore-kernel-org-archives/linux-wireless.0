Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41659 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab0LIOJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 09:09:16 -0500
Received: by vws16 with SMTP id 16so1562137vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 06:09:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
	<AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>
Date: Thu, 9 Dec 2010 15:09:15 +0100
Message-ID: <AANLkTimU1wJo1tDpa+g-_p1fgZqDeNHp5TPH-7Yghqe_@mail.gmail.com>
Subject: Re: [PATCH 0/4] Make N-PHY support experimental
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 7 grudnia 2010 23:57 użytkownik Gábor Stefanik
<netrolller.3d@gmail.com> napisał:
> 2010/12/7 Rafał Miłecki <zajec5@gmail.com>:
>> Finally, thanks for Larry and Francesco I got b43 working with BCM4328 chipset!
>
> Do you mean BCM4321 (14e4:4328)? BCM4328 is AFAIK handled by brcmfmac.

Yeah, I removed following hack some time ago:
-       } else if (bus->chip_id == 0x4321) {
-               /* the BCM4328 has a chipid == 0x4321 and a rev 4 SPROM */
and got lost what is my chipset. You're right.


-- 
Rafał
