Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46627 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab3EIQ0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 12:26:53 -0400
Message-ID: <518BCE45.1060704@candelatech.com> (sfid-20130509_182657_239867_D836D2BB)
Date: Thu, 09 May 2013 09:26:45 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Cyril Segretain <cyrilseg@gmail.com>
CC: Sujith Manoharan <sujith@msujith.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Fun with QoS in AP mode.
References: <5189DB72.3020809@candelatech.com> <20873.56643.216380.594657@gargle.gargle.HOWL> <518A6C21.5070408@candelatech.com> <20875.12412.946993.203664@gargle.gargle.HOWL> <518BB62D.9060108@candelatech.com> <CAJu560hVBcdJ67uNprj0TOY6rWNd-iT8f7QNaE64=ENz91yj6w@mail.gmail.com>
In-Reply-To: <CAJu560hVBcdJ67uNprj0TOY6rWNd-iT8f7QNaE64=ENz91yj6w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2013 08:42 AM, Cyril Segretain wrote:
> Hello,
> I have the same issue but it's with Video streaming, all the frames are in Best_Effort Access Category.
> I work with ath9k driver and hostapd for the AP.
> STA1 <- - - - > AP <--------> Server
> Same software and hardware for STA and AP, WMM enabled in hostapd, hardware support WMM, I don't know where is the problem...
> If you have any idea.

I suspect we need to set up rules with 'tc' and maybe iptables.

I'm not having any luck finding any examples out on the web, but
surely the info is somewhere w/out having to fully understand 'tc'.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

