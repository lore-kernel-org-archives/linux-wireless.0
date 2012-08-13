Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:38487 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab2HMLPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 07:15:24 -0400
Message-ID: <5028E1C9.6050607@neratec.com> (sfid-20120813_131537_776337_4563F645)
Date: Mon, 13 Aug 2012 13:15:21 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "C. McPherson" <ccmcphe@verizon.net>
CC: mcgrof@kernel.org, lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] compat: fix system crash on 2.6.35 when flushing work
References: <1342168714-3361-1-git-send-email-zefir.kurtisi@neratec.com> <5027D79E.9050607@verizon.net>
In-Reply-To: <5027D79E.9050607@verizon.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2012 06:19 PM, C. McPherson wrote:
> Zefir:
> Thanks a lot for this reference. All my systems are running Ubuntu
> 10.04/10.10. I was updating our compat-wireless with the stable
> compat-wireless 3.5
> and came across this crash in our testing lab. I added your patch and
> the stable compat-wireless 3.5 is now working with our Ubuntu.
> 
> -Tex
> 
> 
Hi Tex,

the fix Hauke provided is the correct one. The QH I posted was a lucky
punch that for some reason prevented the system crashing without
resolving the issue.


