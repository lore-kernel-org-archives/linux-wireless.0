Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33193 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbbEQQ3n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2015 12:29:43 -0400
Message-ID: <5558C1F6.2010006@candelatech.com> (sfid-20150517_182950_223255_DDE8AB2B)
Date: Sun, 17 May 2015 09:29:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Stefan Bruens <stefan.bruens@rwth-aachen.de>,
	linux-wireless@vger.kernel.org
Subject: Re: Support of TX timestamps in kernel / by hardware
References: <5898815.03gqQSlLcY@pebbles.site>
In-Reply-To: <5898815.03gqQSlLcY@pebbles.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/17/2015 09:08 AM, Stefan Bruens wrote:
> Hi,
>
> I have looked through the individual hardware drivers, but there seems to be
> no way of getting an accurate time when an individual packet preamble hits the
> antenna.
>
> For RX, most drivers support a RX timestamp based on the TSF and put this into
> struct ieee80211_rx_status -> mactime. For TX, I found nothing related.

I guess a timestamp made in the driver when tx-status is given by the
firmware/hardware might be at least a good estimate.


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
