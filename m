Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61217 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1DLNVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 09:21:45 -0400
MIME-Version: 1.0
In-Reply-To: <op.vtttxt083ri7v4@arend-laptop>
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
	<BANLkTi=jV12tOR_=idn0z+oO_RQ2xaFhCQ@mail.gmail.com>
	<op.vtttxt083ri7v4@arend-laptop>
Date: Tue, 12 Apr 2011 15:21:44 +0200
Message-ID: <BANLkTiksJmiiK53kcP6vm6CTmzXhQa7oTA@mail.gmail.com>
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George Kashperko <george@znau.edu.ua>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Russell King <rmk@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Botting <andy@andybotting.com>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/4/12 Arend van Spriel <arend@broadcom.com>:
> On Tue, 12 Apr 2011 15:04:48 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> There is one more change I started to consider. Is "core" correct name
>> for AXI's device? Almost everywhere we can read about *components* on
>> the AXI interconnect.
>>
>> Maybe it'd make sense to s/core/comp/? Arend?
>
> I have no strong preference on this. I tried the latest patch and it does
> not crash anymore with load/unload.

Could you post dmesg? Probably nothing exciting, just my curiosity :)

-- 
Rafał
