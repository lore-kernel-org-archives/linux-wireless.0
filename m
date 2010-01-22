Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:51798 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab0AVPB7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 10:01:59 -0500
Received: by fg-out-1718.google.com with SMTP id l26so61896fgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2010 07:01:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
References: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 22 Jan 2010 16:01:37 +0100
Message-ID: <69e28c911001220701n7de4f943t60a9eda2b7791608@mail.gmail.com>
Subject: Re: [PATCH 0/5] b43: more N-PHY stuff
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/22 Rafał Miłecki <zajec5@gmail.com>:
> John, I hope to have patch submission fixed, please let me know if there
> is anything wrong still.

Nope, it is still base64-encoded.

I personally use Thunderbird 2 for patch submission (had weird
problems with Thunderbird 3 beta - not sure about the final version).

>
> Rafał Miłecki (5):
>  b43: check band width
>  b43: N-PHY: implement overriding RF control
>  b43: N-PHY: add running samples
>  b43: N-PHY: add setting power amplifier filters
>  b43: N-PHY: add TX tone
>
>  drivers/net/wireless/b43/main.c        |    6 +
>  drivers/net/wireless/b43/phy_common.h  |    3 +
>  drivers/net/wireless/b43/phy_n.c       |  253 ++++++++++++++++++++++++++++++--
>  drivers/net/wireless/b43/tables_nphy.c |   61 ++++++++
>  drivers/net/wireless/b43/tables_nphy.h |   22 +++
>  5 files changed, 330 insertions(+), 15 deletions(-)
>
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
