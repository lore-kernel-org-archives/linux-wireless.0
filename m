Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49075 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab1EJUAy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 16:00:54 -0400
Message-ID: <4DC9996E.2050801@openwrt.org> (sfid-20110510_220056_979130_E8595011)
Date: Tue, 10 May 2011 22:00:46 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	greearb@candelatech.com
Subject: Re: [PATCH 2.6.39] ath9k: fix a regression in PS frame filter handling
References: <1304972747-11775-1-git-send-email-nbd@openwrt.org> <20110510193914.GF2520@tuxdriver.com>
In-Reply-To: <20110510193914.GF2520@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-10 9:39 PM, John W. Linville wrote:
> This doesn't seem to apply against wireless-2.6...
>
> On Mon, May 09, 2011 at 10:25:47PM +0200, Felix Fietkau wrote:
>>  Only leave filtering enabled for AP or VLAN interfaces, clear the
>>  destination mask for all other interfaces.
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  Reported-by: Ben Greear<greearb@candelatech.com>

Ben: You mentioned to me that you bisected the regression to my AP 
powersave related change with 2.6.39-rc6, however this change does not 
appear to be in the 2.6.39 tree at all, so you were probably running a 
bisect on w-t, which has a lot more stuff than w-2.6.

John: Doesn't seem to be relevant for .39 after all, just queue it for 
.40 then.

- Felix
