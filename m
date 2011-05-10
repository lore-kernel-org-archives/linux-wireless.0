Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45187 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab1EJUEi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 16:04:38 -0400
Message-ID: <4DC99A4A.7030701@candelatech.com> (sfid-20110510_220441_247880_74B152E0)
Date: Tue, 10 May 2011 13:04:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [PATCH 2.6.39] ath9k: fix a regression in PS frame filter handling
References: <1304972747-11775-1-git-send-email-nbd@openwrt.org> <20110510193914.GF2520@tuxdriver.com> <4DC9996E.2050801@openwrt.org>
In-Reply-To: <4DC9996E.2050801@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2011 01:00 PM, Felix Fietkau wrote:
> On 2011-05-10 9:39 PM, John W. Linville wrote:
>> This doesn't seem to apply against wireless-2.6...
>>
>> On Mon, May 09, 2011 at 10:25:47PM +0200, Felix Fietkau wrote:
>>> Only leave filtering enabled for AP or VLAN interfaces, clear the
>>> destination mask for all other interfaces.
>>>
>>> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>> Reported-by: Ben Greear<greearb@candelatech.com>
>
> Ben: You mentioned to me that you bisected the regression to my AP
> powersave related change with 2.6.39-rc6, however this change does not
> appear to be in the 2.6.39 tree at all, so you were probably running a
> bisect on w-t, which has a lot more stuff than w-2.6.
>
> John: Doesn't seem to be relevant for .39 after all, just queue it for
> .40 then.

I did run bisect on w-t, and it seems I was confused about it being in
mainline -rcX.

Sorry for the trouble.

Makes me feel a little better though...glad it wasn't in real kernels
and still I was the only one hitting it :P

Ben

>
> - Felix


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

