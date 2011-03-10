Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46502 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1CJSfd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 13:35:33 -0500
Received: by gxk8 with SMTP id 8so777842gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 10:35:32 -0800 (PST)
Message-ID: <4D7919F1.3070106@lwfinger.net>
Date: Thu, 10 Mar 2011 12:35:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Problem with BCM943224
References: <AANLkTim9hhX1VV93X7-+61hNsxit=AJiHgrt9ByWg9+V@mail.gmail.com>	<4D77A06E.3050902@lwfinger.net>	<AANLkTinYp64QZ5o1-=xP_ehVhLPwDLR+gQnQk7MADHFA@mail.gmail.com>	<4D77AD18.60804@lwfinger.net> <AANLkTikb8z-NqGdgWz9Ua+8pWm3Vts2uT9sh7ez6OYVB@mail.gmail.com>
In-Reply-To: <AANLkTikb8z-NqGdgWz9Ua+8pWm3Vts2uT9sh7ez6OYVB@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/10/2011 11:40 AM, Rafał Miłecki wrote:
>
> I guess you do not need that anymore, but I said to check, so... That
> notebook that was shipped with BCM4313 is HP G62-A10sw.
>
> I've taken BCM4313 from that notebook and put it in my cheap adapter.
> It didn't work (again, all reads 1). It seems that my adapter does not
> like any AI based card. It accepts SSB based cards only. At least now
> I know it is not my BCM943223 that is faulty, but adapter. I'm sure
> BCM4313 is fine, because it works OK in that HP notebook.
>
> Bad news: that dumb, dumb, dumb HP has 14e4:4727 (BCM4313)
> whitelisted, but 14e4:4353 (BCM43224) is blacklisted. Who the hell
> designed that :|

The lawyers. HP's argument is that it cannot allow any combination that has not 
been tested for regulatory compliance. It carries about as much validity as 
Broadcom's lawyers not allowing redistribution of firmware for regulatory 
reasons. I've gotten quite good at hot plugging the PCIe card while at the GRUB 
prompt. Someday, I'll get mad enough to rewrite that part of the BIOS.

Other than these screwy BIOS problems, I like HP laptops, but I don't think I'll 
get another of theirs due to this whitelisting problem. I think Dell does not 
have this difficulty. Unfortunately, they seem to offer very few setups with AMD 
processors - my choice.

Larry
