Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3193 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab1DLNTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 09:19:12 -0400
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	=?utf-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"George Kashperko" <george@znau.edu.ua>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"Russell King" <rmk@arm.linux.org.uk>,
	"Arnd Bergmann" <arnd@arndb.de>,
	"Andy Botting" <andy@andybotting.com>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
 <BANLkTi=jV12tOR_=idn0z+oO_RQ2xaFhCQ@mail.gmail.com>
Date: Tue, 12 Apr 2011 15:18:55 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vtttxt083ri7v4@arend-laptop>
In-Reply-To: <BANLkTi=jV12tOR_=idn0z+oO_RQ2xaFhCQ@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 12 Apr 2011 15:04:48 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:

> There is one more change I started to consider. Is "core" correct name
> for AXI's device? Almost everywhere we can read about *components* on
> the AXI interconnect.
>
> Maybe it'd make sense to s/core/comp/? Arend?

I have no strong preference on this. I tried the latest patch and it does  
not crash anymore with load/unload.

Gr. AvS
-- 
"The world is indeed comic, but the joke is on mankind." — H.P. Lovecraft

