Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:34041 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab0HYTHg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 15:07:36 -0400
Message-ID: <4C7569F4.7020605@bu3sch.de>
Date: Wed, 25 Aug 2010 21:07:32 +0200
From: =?ISO-8859-2?Q?Michael_B=FCsch?= <mb@bu3sch.de>
MIME-Version: 1.0
To: =?ISO-8859-2?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH 2/2] b43: N-PHY: add sub calls of band width setting
References: <1282506589-8220-1-git-send-email-zajec5@gmail.com>	<1282506589-8220-2-git-send-email-zajec5@gmail.com>	<AANLkTi=dXNY+Hf8--Yp4VjQBOMwDCFuQqNSi_OAsq=2X@mail.gmail.com>	<AANLkTimeKMR8MfoNKyr6i-JxA8bdqwMKriUbBOagw-z5@mail.gmail.com> <AANLkTi=ELhn1sFmpYn5a1-GcWqVBAeRGC6Kc7OBDLmZw@mail.gmail.com> (sfid-20100822_160429_404901_8D578590)
In-Reply-To: <AANLkTi=ELhn1sFmpYn5a1-GcWqVBAeRGC6Kc7OBDLmZw@mail.gmail.com> (sfid-20100822_160429_404901_8D578590)
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/22/2010 10:04 PM, Gábor Stefanik wrote:
>>>> +#define B43_MMIO_CLKCTL                        0x1E0   /* clock control status */

Is it possible that all this stuff is completely bogus?
All this clock control stuff you are trying to implement really
looks like the standard SSB clock control which is already
implemented in SSB. The clock control and status register
of the chipcommon is 0x1E0.

That "phy reset" stuff also mostly looks like you are reinventing the wheel
for code that is already present.

-- 
Greetings Michael.
