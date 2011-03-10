Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59759 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab1CJRkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 12:40:45 -0500
Received: by qyg14 with SMTP id 14so1673545qyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 09:40:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D77AD18.60804@lwfinger.net>
References: <AANLkTim9hhX1VV93X7-+61hNsxit=AJiHgrt9ByWg9+V@mail.gmail.com>
	<4D77A06E.3050902@lwfinger.net>
	<AANLkTinYp64QZ5o1-=xP_ehVhLPwDLR+gQnQk7MADHFA@mail.gmail.com>
	<4D77AD18.60804@lwfinger.net>
Date: Thu, 10 Mar 2011 18:40:44 +0100
Message-ID: <AANLkTikb8z-NqGdgWz9Ua+8pWm3Vts2uT9sh7ez6OYVB@mail.gmail.com>
Subject: Re: Problem with BCM943224
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 9 marca 2011 17:38 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> On 03/09/2011 10:26 AM, Rafał Miłecki wrote:
>>
>> BCM4322 is not a problem for me as well. I can use BCM4312, BCM4321,
>> BCM4322 with my adapter without problem.
>>
>> It's BCM943224 that I hit this problem with.
>>
>> AFAIR you have some AI based card. Could you test this with your
>> extender for me?
>
> Sorry, I have no AI-based card. I checked for a BCM4313 on Ebay a couple of
> weeks ago and couldn't find one. I know that Dell ships that card in some
> laptops, but I couldn't find the part on their web site. Does anyone know
> the Dell part number?

I guess you do not need that anymore, but I said to check, so... That
notebook that was shipped with BCM4313 is HP G62-A10sw.

I've taken BCM4313 from that notebook and put it in my cheap adapter.
It didn't work (again, all reads 1). It seems that my adapter does not
like any AI based card. It accepts SSB based cards only. At least now
I know it is not my BCM943223 that is faulty, but adapter. I'm sure
BCM4313 is fine, because it works OK in that HP notebook.

Bad news: that dumb, dumb, dumb HP has 14e4:4727 (BCM4313)
whitelisted, but 14e4:4353 (BCM43224) is blacklisted. Who the hell
designed that :|

-- 
Rafał
