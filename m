Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost03.isp.att.net ([207.115.11.53]:38282 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbZFAWRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 18:17:06 -0400
Message-ID: <4A245361.9060807@lwfinger.net>
Date: Mon, 01 Jun 2009 17:17:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: matthieu castet <castet.matthieu@free.fr>
CC: linux-wireless@vger.kernel.org
Subject: Re: b43 vs b43legacy
References: <loom.20090529T190620-42@post.gmane.org> <4A20505D.40908@lwfinger.net> <4A244C5A.50307@free.fr>
In-Reply-To: <4A244C5A.50307@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

matthieu castet wrote:
> Larry Finger wrote:
>> Matthieu CASTET wrote:
>>> what's the difference between b43 and b43legacy ?
>>>
>>> >From a first point a view, it seems b43 is for core >= 5 and
>>> b43legacy for the
>>> other.
>>> There is also firmware difference : b43 need v4 and b43legacy need v3.
>>
>> The firmware difference is the primary one.
>>
>>> But v4 firmware seems to support core 4 (pcm4 & ucode4) and b43 code
>>> got some
>>> support for old chips (<5).
>>
>> The Broadcom V4 drivers do have core 4 firmware embedded in them and
>> it is
>> extracted by b43-fwcutter; however, b43 will _NOT_ work with core 4
>> chips. The
>> firmware loader will only find firmware for core 5 and later.
> Ok but what prevent b43 to support core 4 chip with v4 firmware like the
> broadcom driver does ?
> I am aware that the current driver doesn't support it, but what are the
> missing part to support it ?

The firmware loader code is the first step. Beyond that, I have no idea.

> If it is the difference from core4 from newer chip, why b43legacy
> contains only few special case for core4 chip.

I do not know other than that is what the specs called for.

> PS : I don't have core 4 chip nor plan to get some, I ask this out of
> curiosity.

I do have such a chip, but I use it to verify b43legacy code.

Larry

