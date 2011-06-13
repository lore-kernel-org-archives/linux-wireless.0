Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50597 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab1FMSSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 14:18:40 -0400
Message-ID: <4DF65472.9070601@candelatech.com> (sfid-20110613_201844_581048_F9A562F7)
Date: Mon, 13 Jun 2011 11:18:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Fred Matthews <fredmm@hotmail.co.uk>
CC: ionic@ionic.de, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [ath9k-devel] AR9380 current driver supported features
References: <BLU158-w3633DDF37956A9F5672C1F87690@phx.gbl> <BLU158-w58841DE4774E18813C30CA87690@phx.gbl>
In-Reply-To: <BLU158-w58841DE4774E18813C30CA87690@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/13/2011 11:09 AM, Fred Matthews wrote:
>
> Hi,I am looking to upgrade my current nodes and AP from the AR9280 2x2 MIMO NIC to the AR9380 3x3 NIC.
> Thus I was wondering if someone can kindly comment on the current chipset stability with ath9k, also the current supported features (e.g.  "iw list" output) such as setting the NIC as an AP/Master using hostapd, Greenfield mode, TxBF, CSI info, and LPDC as well as rates achieved.
> Thanks in advance 		 	   		

Both are stable in our testing (virtual stations, AP mode), but we're having
a hard time sourcing AR9380 3x3 NICs..getting ship-times in August, etc....

I don't have details on the other things you ask about.

I'd suggest getting a few NICs and trying them out in your environment.
Even if they have problems, there are folks actively working on it and
likely it can be fixed.  And at least for our use with virtual stations & APs,
there is no other NIC that comes close to the features that Atheros offers.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

