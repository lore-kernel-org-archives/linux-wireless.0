Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50397 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaBSTsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 14:48:08 -0500
Message-ID: <53050A58.4000706@candelatech.com> (sfid-20140219_204812_024917_5887B064)
Date: Wed, 19 Feb 2014 11:47:36 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: fix sta_rc_update for non-ap iftype
References: <CA+BoTQmNdn3ELFRyiMwRE=nq5XukvSy2m7BNoqXnoz95JuDYOw@mail.gmail.com> <1392795187-2870-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1392795187-2870-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2014 11:33 PM, Michal Kazior wrote:
> The arsta structure wasn't initialized for
> non-ap interfaces. This should fix related
> warnings/crashes.
> 
> Reported-By: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
> Ben, does this fix the lockdep splat for you?

This does appear to fix it.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

