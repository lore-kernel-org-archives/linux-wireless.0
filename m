Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44906 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1BIXgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 18:36:54 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p19Nar3S019393
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Feb 2011 15:36:54 -0800
Message-ID: <4D532515.6020500@candelatech.com>
Date: Wed, 09 Feb 2011 15:36:53 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k and pktgen generate WARNings.
References: <4D531CA6.8010903@candelatech.com>
In-Reply-To: <4D531CA6.8010903@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2011 03:00 PM, Ben Greear wrote:
> I see this warning when I generate traffic with a hacked version
> of pktgen. This works with various other interfaces w/out problems,
> so I think it's probably an ath9k and/or mac80211 bug.

This stuff hurts my head..but maybe this will help:

tidno: 0  tid->ac->txq: f050dc5c  txctl->txq: f050db4c
  tid->ac->txq: mac80211_qnum: 2  axq_qnum: 2
  txctl->txq: mac80211_qnum: 0  axq_qnum: 0

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

