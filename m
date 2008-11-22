Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:23777 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405AbYKVMdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 07:33:24 -0500
Received: by mu-out-0910.google.com with SMTP id g7so1387210muf.1
        for <linux-wireless@vger.kernel.org>; Sat, 22 Nov 2008 04:33:22 -0800 (PST)
Message-ID: <4927FC0C.10900@gmail.com> (sfid-20081122_133329_699469_CABB1F37)
Date: Sat, 22 Nov 2008 14:33:16 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: Derek Smithies <derek@indranet.co.nz>
CC: Bob Copeland <me@bobcopeland.com>, wally@theblackmoor.net,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ath5k-devel] Unusually low speeds with ath5k and iwl3945
References: <492719ED.5000006@gmail.com> <20081122005240.GA27826@hash.localnet> <alpine.DEB.2.00.0811221643030.7067@monster>
In-Reply-To: <alpine.DEB.2.00.0811221643030.7067@monster>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Derek Smithies wrote:
> Hi,
>  to verify that it is a rate control issue, there is one very simple and 
> very practical test.
> 
> Take both ends of your link, and set them to fixed rate, and at the rate 
> you think it should be achieving.
> If you can achieve significantly higher throughputs with fixed rate, you 
> know that the rate control algorithm (or interface with rate algorithm) 
> has failed.
> 
> Derek.
> 
> On Fri, 21 Nov 2008, Bob Copeland wrote:
> 
>> On Fri, Nov 21, 2008 at 10:28:29PM +0200, Maxim Levitsky wrote:
>>> I initially blamed iwl3945, then thought it got fixed, but now I have
>>> ath5k, and speeds are low
>>> and I suspect that both drivers has bugs regarding to speed.
>>
>> Quite possible, but both use mac80211 for rate control.  Which rate
>> control algorithm are you using?
Hi,

Well, iwl3945 was showing 54M all the time in iwconfig,
also it doesn't support setting fixed rate, at least not using iwconfig.

ath5k never shows higher that 18M, and supports setting fixed rate, but if I set it to anything higher that 18M,
speeds drop to 0Kbytes/s immediately.
Speeds lower that 18M work, and affect throughput accordantly
For most of tests speeds are ether 18M or lower, but then when I set them to 18M this didn't increase throughput.
 
iwl3945 was always at 54M



Best regards,
	Maxim Levitsky
