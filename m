Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47937 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0LGW5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 17:57:52 -0500
Received: by qyk12 with SMTP id 12so477783qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 14:57:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 7 Dec 2010 23:57:31 +0100
Message-ID: <AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>
Subject: Re: [PATCH 0/4] Make N-PHY support experimental
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/7 Rafał Miłecki <zajec5@gmail.com>:
> Finally, thanks for Larry and Francesco I got b43 working with BCM4328 chipset!

Do you mean BCM4321 (14e4:4328)? BCM4328 is AFAIK handled by brcmfmac.

>
> It's not perfectly stable yet, but scanning and associating to open network
> works! It has to be tested, improved, there are some PHY errors from time to
> time, but generally it works :)
>
> Rafał Miłecki (4):
>  b43: N-PHY: silence warnings
>  b43: set TMS to work with current band width for N-PHY
>  b43: fix split of N-PHY devices into supported and not (based on PHY
>    rev)
>  b43: rename config option for N-PHY, drop BROKEN
>
>  drivers/net/wireless/b43/Kconfig      |   13 +++++++------
>  drivers/net/wireless/b43/Makefile     |    8 ++++----
>  drivers/net/wireless/b43/main.c       |   12 +++++++++---
>  drivers/net/wireless/b43/phy_common.c |    9 ++++++++-
>  drivers/net/wireless/b43/phy_common.h |    2 ++
>  drivers/net/wireless/b43/phy_n.c      |   16 ++++++----------
>  6 files changed, 36 insertions(+), 24 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
