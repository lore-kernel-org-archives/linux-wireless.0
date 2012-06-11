Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58754 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2FKRxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 13:53:00 -0400
Message-ID: <4FD63078.9000808@candelatech.com> (sfid-20120611_195304_117371_9EBEA353)
Date: Mon, 11 Jun 2012 10:52:56 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Antonis Hadjiantonis <contact@antonis.mobi>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k rate control statistics not updated for UDP
References: <loom.20120611T152810-2@post.gmane.org>
In-Reply-To: <loom.20120611T152810-2@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/2012 06:37 AM, Antonis Hadjiantonis wrote:
> I am using iperf to test rate control algorithms (use default:minstrel_ht) on an
> ath9k device (WRT160NL OpenWRT Backfire 10.3.1 r29592).
> When I use UDP traffic over an 802.11g connection, the rcstat file is not
> updated. Not sure if the rate control algoritmh works during the process.
> If I use TCP traffic, rcstat is updated and statistics/rate change accordingly.
>
> Is this the correct behaviour of minstrel RC? I went through documentation
> regarding MRR and retransmission bounds but wasn't able to figure it out. Any
> one noticed something similar?

Your UDP traffic may be completely uni-directional, so no packets
are ever received.  Maybe try setting up a bi-directional traffic
flow?

Ben

>
> Thanks in advance,
> Antonis
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

