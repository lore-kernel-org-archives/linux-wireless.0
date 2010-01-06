Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34913 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318Ab0AFXMi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 18:12:38 -0500
Received: by ewy19 with SMTP id 19so10189014ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 15:12:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B4515CA.7050902@lwfinger.net>
References: <op.u54a5ufy9lhzdc@linux-g0th.site>
	 <201001061650.52062.mb@bu3sch.de>
	 <b170af451001061211y51b3ca6do11fb24fbb1193c51@mail.gmail.com>
	 <op.u54ppc2h9lhzdc@linux-g0th.site>
	 <69e28c911001061435v4b840588p3ead478672ba311@mail.gmail.com>
	 <b170af451001061445k56872cd1hbae81a59e421da73@mail.gmail.com>
	 <69e28c911001061449v3f58ce1vc4bfefcdbaf81fa2@mail.gmail.com>
	 <4B4515CA.7050902@lwfinger.net>
Date: Thu, 7 Jan 2010 00:12:37 +0100
Message-ID: <b170af451001061512h6668a9cbyd275799c5cb37aa5@mail.gmail.com>
Subject: Re: [PATCH 1/5] b43: N-PHY: implement b43_nphy_stay_in_carrier_search
	and it's calls (V2)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 6 stycznia 2010 23:59 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> On 01/06/2010 04:49 PM, Gábor Stefanik wrote:
>> 2010/1/6 Rafał Miłecki <zajec5@gmail.com>:
>>> W dniu 6 stycznia 2010 23:35 użytkownik Gábor Stefanik
>>> <netrolller.3d@gmail.com> napisał:
>>>> 2010/1/6 Rafał Miłecki <zajec5@gmail.com>:
>>>>> V2: fix typo in deaf_count counting, improve b43_mac_[sr] calls,
>>>>>    rename function. Thanks Michael!
>>>>>
>>>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>>>> ---
>>>>>  drivers/net/wireless/b43/phy_n.c |   58
>>>>> ++++++++++++++++++++++++++++++++++++++
>>>>>  drivers/net/wireless/b43/phy_n.h |    3 ++
>>>>>  2 files changed, 61 insertions(+), 0 deletions(-)
>>>>>
>>>>> <snip>
>>>>
>>>> Typo in title (it's vs. its)
>>>
>>> My gramma is far from perfect, thanks.
>>
>> I've yet to see a perfect grandmother... :-)
>
> My wife thinks she is perfect!

What a one latter can change ;)

-- 
Rafał
