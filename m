Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:45288 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab0AFWtp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 17:49:45 -0500
Received: by fxm25 with SMTP id 25so11210276fxm.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 14:49:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b170af451001061445k56872cd1hbae81a59e421da73@mail.gmail.com>
References: <op.u54a5ufy9lhzdc@linux-g0th.site> <201001061650.52062.mb@bu3sch.de>
	<b170af451001061211y51b3ca6do11fb24fbb1193c51@mail.gmail.com>
	<op.u54ppc2h9lhzdc@linux-g0th.site> <69e28c911001061435v4b840588p3ead478672ba311@mail.gmail.com>
	<b170af451001061445k56872cd1hbae81a59e421da73@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 6 Jan 2010 23:49:21 +0100
Message-ID: <69e28c911001061449v3f58ce1vc4bfefcdbaf81fa2@mail.gmail.com>
Subject: Re: [PATCH 1/5] b43: N-PHY: implement b43_nphy_stay_in_carrier_search
	and it's calls (V2)
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/6 Rafa³ Mi³ecki <zajec5@gmail.com>:
> W dniu 6 stycznia 2010 23:35 u¿ytkownik Gábor Stefanik
> <netrolller.3d@gmail.com> napisa³:
>> 2010/1/6 Rafa³ Mi³ecki <zajec5@gmail.com>:
>>> V2: fix typo in deaf_count counting, improve b43_mac_[sr] calls,
>>>    rename function. Thanks Michael!
>>>
>>> Signed-off-by: Rafa³ Mi³ecki <zajec5@gmail.com>
>>> ---
>>>  drivers/net/wireless/b43/phy_n.c |   58
>>> ++++++++++++++++++++++++++++++++++++++
>>>  drivers/net/wireless/b43/phy_n.h |    3 ++
>>>  2 files changed, 61 insertions(+), 0 deletions(-)
>>>
>>> <snip>
>>
>> Typo in title (it's vs. its)
>
> My gramma is far from perfect, thanks.

I've yet to see a perfect grandmother... :-)

>
> --
> Rafa³
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
