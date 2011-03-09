Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61288 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab1CISED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 13:04:03 -0500
Received: by qyg14 with SMTP id 14so702682qyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 10:04:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D77B4B6.8030603@lwfinger.net>
References: <AANLkTim9hhX1VV93X7-+61hNsxit=AJiHgrt9ByWg9+V@mail.gmail.com>
	<4D77A06E.3050902@lwfinger.net>
	<AANLkTinYp64QZ5o1-=xP_ehVhLPwDLR+gQnQk7MADHFA@mail.gmail.com>
	<4D77AD18.60804@lwfinger.net>
	<AANLkTingWDXtuxWtQwkVFbhOnfHmAPsp1KsyQWJcRBqR@mail.gmail.com>
	<4D77B4B6.8030603@lwfinger.net>
Date: Wed, 9 Mar 2011 19:04:01 +0100
Message-ID: <AANLkTinEC5b6-vP_zc2RE2Juc8YFx8nkEK7isvQw+UVX@mail.gmail.com>
Subject: Re: Problem with BCM943224
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do you think buying some more expensive adapter could help? The newest
offered by hwtools seems to be:
http://www.hwtools.net/Adapter/MP2H.html
(ver 2.2). It is not so expensive at all, $15 without shipping.

I've already written to them with question about BCM943224
compatibility (they don't have that chipset on their list).

Stanisław: I remember you telling that you have such a adapter. Do you
maybe have access to some BCM943224/BCM94313 card? Could you test that
combo for me, please?

The only other solution I can see is to buy motherboard with mini PCIe
slot. There are some *D410P* (BLKD410PT, BOXD410PT, BLKD410PTL,
D410PT) and D510MO having such a slow (and Atom CPU.... :/). Kernel
compilation would be disaster but I think I could live with that. Do
you think such a boards would be compatible with Broadcom's cards?

-- 
Rafał
