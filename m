Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57790 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab0HYP7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 11:59:22 -0400
Message-ID: <4C753DD0.9040702@candelatech.com>
Date: Wed, 25 Aug 2010 08:59:12 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Wei Qiang <weiqiang@chinacablecom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: AR7240 VLAN setup
References: <B94E9F5324F243B5B714A70B147C8CB1@lenovodbc34d11>
In-Reply-To: <B94E9F5324F243B5B714A70B147C8CB1@lenovodbc34d11>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/25/2010 02:13 AM, Wei Qiang wrote:
> *Hi, Ben,*
>
> * *
>
> * Sorry for bother.*
>
> * *
>
> * I have a question about how to setup 802.1Q VLAN on AR7240, and can’t get any answer for days. When I googled “802.1q ar7240”, I noticed that you were the
> supporter of 802.1q module. It seems that you are the only one who may help me resolve the problem now. Support from Atheros is poor.*

You might try the linux wireless mailing list:
"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>

I have only messed with VLANs on wired interfaces.

Thanks,
Ben

>
> * *
>
> * The problem itself is quite straight forward: *
>
> * *
>
> *1. All packets to ingress LAN port should have a VLAN tag added, or the tag should be removed at egress LAN port.*
>
> * 2. WAN port will transmit all packets unmodified.*
>
> * *
>
> * If you may have an instruction of how to set AR7240 up, or have some related documents to me, that will be great.*
>
> * *
>
> * I have tried different combinations of those registers, but none of them works.*
>
> * *
>
> * This issue is very important for me, and your help is highly appreciated!*
>
> * *
>
> *Thanks and regards,*
>
> * *
>
> *Wei*
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
