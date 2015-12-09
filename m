Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60851 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbbLIPds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 10:33:48 -0500
Message-ID: <566849DB.9040901@candelatech.com> (sfid-20151209_163351_750004_46E25132)
Date: Wed, 09 Dec 2015 07:33:47 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Cedric VONCKEN <cedric.voncken@acksys.fr>,
	ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ATH10K VLAN firmware issue
References: <773DB8A82AB6A046AE0195C68612A31901C5B293@sbs2003.acksys.local>
In-Reply-To: <773DB8A82AB6A046AE0195C68612A31901C5B293@sbs2003.acksys.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This only happens when you use STA  + WDS, or is .1q broken
for you in other cases as well?

Thanks,
Ben

On 12/08/2015 06:29 AM, Cedric VONCKEN wrote:
> 	I'm testing to transmit frame with 802.1q tag (VLAN).
>
> 	My client is set in STA + WDS and the netdev is bridged with
> eth0.
> 	I have a computer with vlan configuration set connected to the
> STA eth0.
>
> 	If I try to transmit frames with 802.1q tag, the frames are not
> sent.
> 	I checked with wireless sniffer, and I don't see the frame with
> VLAN tag (the frames without VLAN tag are sent).
>
> 	I tested with firmware 10.2.4.70.14-2 from kale github,
> 10.1.467-ct-com-full-015 from candelatech and 10.2.4.70-2 from openwrt,
> and in all cases I have the same issue.
>
> 	Thanks for your help.
>
> 	
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
