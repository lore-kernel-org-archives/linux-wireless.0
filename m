Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64995 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258Ab2ENVma convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 17:42:30 -0400
Received: by bkcji2 with SMTP id ji2so4248646bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 14:42:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FB1735D.2000902@lwfinger.net>
References: <4FB15D76.9000302@lwfinger.net>
	<CA++WF2M18LBx2OfKs47pr3=Z=yfOf43YEVv7-CshzMVrFcgmKg@mail.gmail.com>
	<4FB1735D.2000902@lwfinger.net>
Date: Mon, 14 May 2012 14:42:29 -0700
Message-ID: <CA++WF2PUyRyU_URQFvw0UhK5w=_zAcHKxmyujvY1aQYmuY1u8g@mail.gmail.com> (sfid-20120514_234234_123453_BDD24536)
Subject: Re: Warning from wireless-testing for ipw2100
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 May 2012 14:04, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 05/14/2012 03:53 PM, Stanislav Yakovlev wrote:
>>
>> Hello Larry,
>>
>> On 14 May 2012 12:31, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>>>
>>> A freshly pulled copy of wireless-testing 3.4-rc7 has the following
>>> warning
>>> that the 802.11 band has not been set when the ipw2100 driver is probed:
>>> [   17.766431] ------------[ cut here ]------------
>>> [   17.766467] WARNING: at net/wireless/core.c:562
>>> wiphy_register+0x34c/0x3c0 [cfg80211]()
>>
>>
>> I think it is the same problem as for ipw2200 as found by Stefan
>> http://marc.info/?l=linux-wireless&m=132720334512946&w=2
>>
>> which is already fixed.
>> http://marc.info/?l=linux-wireless&m=133457257407196&w=2
>>
>>> ....
>>> I do not use the device and it doesn't make any difference to me, but
>>> there
>>> may be someone that needs it.
>>
>>
>> I will send a patch.
>
>
> If you mean the patch in the second URL above, it has already been applied
> to my source.

There were two almost identical changes:
http://marc.info/?l=linux-wireless&m=132720195012653&w=2
http://marc.info/?l=linux-wireless&m=132720204412667&w=2

First one broke ipw2200, and the second one broke ipw2100.
The patch I mentioned fixes ipw2200 and does not fix ipw2100.

Stanislav.
