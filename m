Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:38073 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab3GORct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 13:32:49 -0400
Date: Mon, 15 Jul 2013 19:32:45 +0200
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 3.11] mac80211/minstrel: fix NULL pointer dereference
 issue
Message-ID: <20130715173245.GA19279@shrek.podlesie.net> (sfid-20130715_193251_467416_119FD562)
References: <1373891706-1071-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1373891706-1071-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 15, 2013 at 02:35:06PM +0200, Felix Fietkau wrote:
> When priv_sta == NULL, mi->prev_sample is dereferenced too early. Move
> the assignment further down, after the rate_control_send_low call.
> 
> Reported-by: Krzysztof Mazur <krzysiek@podlesie.net>
> Cc: stable@vger.kernel.org # 3.10
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  net/mac80211/rc80211_minstrel.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Works for me.

Thanks,
Krzysiek
