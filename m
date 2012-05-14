Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54654 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813Ab2ENVEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 17:04:34 -0400
Received: by yenm10 with SMTP id m10so4708160yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 14:04:34 -0700 (PDT)
Message-ID: <4FB1735D.2000902@lwfinger.net> (sfid-20120514_230439_103510_5B51517E)
Date: Mon, 14 May 2012 16:04:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Warning from wireless-testing for ipw2100
References: <4FB15D76.9000302@lwfinger.net> <CA++WF2M18LBx2OfKs47pr3=Z=yfOf43YEVv7-CshzMVrFcgmKg@mail.gmail.com>
In-Reply-To: <CA++WF2M18LBx2OfKs47pr3=Z=yfOf43YEVv7-CshzMVrFcgmKg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/14/2012 03:53 PM, Stanislav Yakovlev wrote:
> Hello Larry,
>
> On 14 May 2012 12:31, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> A freshly pulled copy of wireless-testing 3.4-rc7 has the following warning
>> that the 802.11 band has not been set when the ipw2100 driver is probed:
>> [   17.766431] ------------[ cut here ]------------
>> [   17.766467] WARNING: at net/wireless/core.c:562
>> wiphy_register+0x34c/0x3c0 [cfg80211]()
>
> I think it is the same problem as for ipw2200 as found by Stefan
> http://marc.info/?l=linux-wireless&m=132720334512946&w=2
>
> which is already fixed.
> http://marc.info/?l=linux-wireless&m=133457257407196&w=2
>
>> ....
>> I do not use the device and it doesn't make any difference to me, but there
>> may be someone that needs it.
>
> I will send a patch.

If you mean the patch in the second URL above, it has already been applied to my 
source.

Larry

