Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57808 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab1EXPFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 11:05:51 -0400
Message-ID: <4DDBC947.4020801@candelatech.com> (sfid-20110524_170555_109398_C4DB9A06)
Date: Tue, 24 May 2011 08:05:43 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: Brian Prodoehl <bprodoehl@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k 9380: All 5Ghz channels flagged as passive-scanning
References: <4DD6E9B5.3020905@candelatech.com>	<BANLkTindTMFNNpyNpNndhhGv7qWB5_haGQ@mail.gmail.com>	<4DDA913B.1060002@candelatech.com>	<4DDAA9ED.1050606@candelatech.com>	<4DDAACF3.3050705@candelatech.com>	<BANLkTikvwq+0GYDxgEXNfhkcntjmpOdpPQ@mail.gmail.com> <BANLkTinWnLryxtqTF3b0rr0f8VO=Y2Jkmw@mail.gmail.com>
In-Reply-To: <BANLkTinWnLryxtqTF3b0rr0f8VO=Y2Jkmw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/24/2011 07:08 AM, Mohammed Shafi wrote:
> On Tue, May 24, 2011 at 6:30 PM, Brian Prodoehl<bprodoehl@gmail.com>  wrote:

>> This is running 2.6.37 with compat-wireless from sometime in March,
>> probably.  I'll try with 2.6.39 and latest compat-wireless when I get
>> a chance.
>>
>
> I got the similar result with latest wireless testing

I'm running wireless-testing as well.  I think the code is probably correct,
just that the NIC I bought happened to be programmed for a different regdomain
than 0x0.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
