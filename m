Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38790 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab0JZQdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 12:33:10 -0400
Message-ID: <4CC702C5.6090907@candelatech.com>
Date: Tue, 26 Oct 2010 09:33:09 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org, kyungwan.nam@atheros.com
Subject: Re: [RFT 0/3] ath9k: more PCU locking enhancements
References: <1288082441-4882-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1288082441-4882-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2010 01:40 AM, Luis R. Rodriguez wrote:
> Here is some more PCU locking enhancements I tested today
> while trying to resolve the WARN() that happens when we
> try to stop RX DMA and fail. While working on that I figured
> I'd work on the TX DMA stuff too, here's a shot at it. I
> can no longer get TX / RX DMA rants, please test and let
> me know if you do. I only tried some basic testing like
> rmmoding while scannign, which typicallly produced some
> errors. Now I don't get squat.
>
> Ben if you can test wit your super proprietary application
> that'd be great.

I'll make every effort, we should have some testing results later
today.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

