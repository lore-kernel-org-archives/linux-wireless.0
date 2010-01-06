Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:29150 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab0AFWfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 17:35:36 -0500
Received: by fg-out-1718.google.com with SMTP id 22so7062553fge.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 14:35:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <op.u54ppc2h9lhzdc@linux-g0th.site>
References: <op.u54a5ufy9lhzdc@linux-g0th.site> <201001061650.52062.mb@bu3sch.de>
	<b170af451001061211y51b3ca6do11fb24fbb1193c51@mail.gmail.com>
	<op.u54ppc2h9lhzdc@linux-g0th.site>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 6 Jan 2010 23:35:13 +0100
Message-ID: <69e28c911001061435v4b840588p3ead478672ba311@mail.gmail.com>
Subject: Re: [PATCH 1/5] b43: N-PHY: implement b43_nphy_stay_in_carrier_search
	and it's calls (V2)
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/6 Rafał Miłecki <zajec5@gmail.com>:
> V2: fix typo in deaf_count counting, improve b43_mac_[sr] calls,
>    rename function. Thanks Michael!
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/phy_n.c |   58
> ++++++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/b43/phy_n.h |    3 ++
>  2 files changed, 61 insertions(+), 0 deletions(-)
>
> <snip>

Typo in title (it's vs. its)

>
> --
> 1.6.4.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
