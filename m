Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34206 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935382Ab3DPD4O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 23:56:14 -0400
Message-ID: <516CCBDA.6070409@candelatech.com> (sfid-20130416_055622_407200_5C4EEF66)
Date: Mon, 15 Apr 2013 20:56:10 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath10k-devel@qca.qualcomm.com
Subject: Re: ath10k: mac80211 driver for QCA9880
References: <87li8k0yu1.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87li8k0yu1.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/15/2013 05:20 AM, Kalle Valo wrote:
> Hi,
>
> I just pushed initial version of ath10k, our new driver for QCA9880 &
> co, to github.com:
>
> https://github.com/kvalo/ath10k
>
> The driver is pretty small, roughly 14 kLOC. Even if the name implies
> that this is an evolution from ath9k, the drivers are actually very
> different. The biggest difference is that there's now firmware running
> on the chip.
>
> Once ath10k is ready I will send it for proper review. But we are not
> quite there yet.

Is there any info on it's expected support for virtual stations, APs, etc?

Hardware is still hard to come by it seems..hope that changes soon!

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

