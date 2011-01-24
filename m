Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41852 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab1AXSaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 13:30:35 -0500
Message-ID: <4D3DC535.7040300@candelatech.com>
Date: Mon, 24 Jan 2011 10:30:13 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH] ath9k: fix misplaced debug code
References: <1295892714-985-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1295892714-985-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/24/2011 10:11 AM, Felix Fietkau wrote:
> The commit 'ath9k: Add more information to debugfs xmit file.' added more
> debug counters to ath9k and also added some lines of code to ath9k_hw.
>
> Since ath9k_hw is also used by ath9k_htc, its code must not depend on ath9k
> data structures. In this case it was not fatal, but it's still wrong, so
> the code needs to be moved back to ath9k.
>
> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
> Cc: Ben Greear<greearb@candelatech.com>

Thanks for fixing that..I wasn't aware of that problem.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

