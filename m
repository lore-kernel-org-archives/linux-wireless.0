Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59977 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbbIQVpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 17:45:13 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 4EEC240A5C4
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2015 14:45:13 -0700 (PDT)
Subject: Re: Use iw to disable all rates for a particular rateset?
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <55FB3297.90909@candelatech.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <55FB3468.9000508@candelatech.com> (sfid-20150917_234520_646503_8956F4BF)
Date: Thu, 17 Sep 2015 14:45:12 -0700
MIME-Version: 1.0
In-Reply-To: <55FB3297.90909@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/17/2015 02:37 PM, Ben Greear wrote:
> Is there any way to have iw configure to use *just* legacy
> rates, for instance:
>
> iw dev wlan0 bitrates legacy-2.4 1 2 5.5 11 [and disable all others, including HT and VHT] ?

Err, nevermind..I think this is the second time I thought this was broken,
but I just was not using things properly.

Thanks,
Ben

>
>  From what I can tell, there is not.
>
> I need a way to disable HT and VHT rates before a peer exists so that I can cause
> probe requests to go out without any HT/VHT info in them, for instance.
>
> Thanks,
> Ben
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

