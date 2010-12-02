Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43009 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab0LBSQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 13:16:52 -0500
Message-ID: <4CF7E292.3060405@candelatech.com>
Date: Thu, 02 Dec 2010 10:16:50 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k: invalid hw_rix with 64 stations.
References: <4CF6ED18.5010704@candelatech.com>	<4CF6EE43.2020905@candelatech.com>	<AANLkTi=tRagv2dC8Vh3kQz1CFifPXOB3wNdhvGGziOSE@mail.gmail.com>	<4CF73BC6.8080400@candelatech.com> <AANLkTik8KPAw=C-EJaUSAq2acUMWxD5cd=5htjm3-PnY@mail.gmail.com>
In-Reply-To: <AANLkTik8KPAw=C-EJaUSAq2acUMWxD5cd=5htjm3-PnY@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/02/2010 08:18 AM, Nick Kossifidis wrote:
> 2010/12/2 Ben Greear<greearb@candelatech.com>:

>
> At least try skipping 11a on ath5k_setup_bands, just comment out the 11a part...

I did this, and it took a bit longer than last time to see the errors,
but they still do happen.  The 'longer' might just be random luck,
and the kernel was compiled with more debugging enabled...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

