Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:35803 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755370Ab2B1L1g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 06:27:36 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com
Subject: Re: [PATCH v2] {nl,cfg,mac}80211: Implement RSSI threshold for mesh peering
References: <1330382334-3899-1-git-send-email-ashok@cozybit.com>
Date: Tue, 28 Feb 2012 13:27:34 +0200
In-Reply-To: <1330382334-3899-1-git-send-email-ashok@cozybit.com> (Ashok
	Nagarajan's message of "Mon, 27 Feb 2012 14:38:54 -0800")
Message-ID: <87ty2bb3kp.fsf@purkki.adurom.net> (sfid-20120228_122740_776764_0AA4DA0A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ashok Nagarajan <ashok@cozybit.com> writes:

> Mesh peer links are established only if average rssi of the peer
> candidate satisfies the threshold. This is not in 802.11s specification
> but was requested by David Fulgham, an open80211s user. This is a way to avoid
> marginal peer links with stations that are barely within range.
>
> This patch adds a new mesh configuration parameter, mesh_rssi_threshold.
>
> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
> Signed-off-by: Javier Cardona <javier@cozybit.com>

[...]

> +	int32_t  rssi_threshold;

Why int32_t? Why not s32?

Doesn't make any difference, but I'm curious.

-- 
Kalle Valo
