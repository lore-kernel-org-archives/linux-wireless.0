Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57827 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2KIGqy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 01:46:54 -0500
Received: by mail-we0-f174.google.com with SMTP id t9so1603072wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2012 22:46:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAF1EbZh=mPKVy=G4AgK1Fz6FxJjnAgaHdoGt6Uwohe+fvhYkgg@mail.gmail.com>
References: <CAF1EbZh=mPKVy=G4AgK1Fz6FxJjnAgaHdoGt6Uwohe+fvhYkgg@mail.gmail.com>
Date: Fri, 9 Nov 2012 07:46:52 +0100
Message-ID: <CACna6ryLuoEZeTTP9g-RfY-1QofGMf4445huU8PZSyEv8ZSxSA@mail.gmail.com> (sfid-20121109_074709_383923_ECB4708A)
Subject: Re: [help] WiFi connection //Re: [PATCH][2.6.39?] b43: trivial:
 update module info about firmware
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?B?WmhvdSBoYW5neGluZyDlkajooYzooYw=?=
	<hangxing.zhou@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/11/9 Zhou hangxing 周行行 <hangxing.zhou@gmail.com>:
> One question about WiFi connect event in driver layer. I appreciate some
> information from your guys if possible.
>
> There is a device_A with WiFi module,  the application in smart
> phone(iPhone) can communicate with the device_A via socket connection.
>
> In this case, if user goes to setting screen in iPhone, and disable the WiFi
> directly( the application is still running).
>
> Does the driver layer know the status of WiFi connection in device_A?
> Or any event message can be indicated by WiFi driver in device_A?

So... are you using Linux on iPhone? Some Android port?

What WiFi chipset does it have? Some BCM4312 (LP-PHY) with higher PHY
rev? I though phones are usually using fullmac devices...

You way want to check rfkill, but I'm not sure it Android is using that.

-- 
Rafał
