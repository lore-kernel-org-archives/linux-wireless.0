Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11252 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbbJEPaa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:30:30 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vivek Natarajan <nataraja@qti.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2] ath10k: Use station's current operating mode from assoc request
References: <1443168068-5719-1-git-send-email-nataraja@qti.qualcomm.com>
Date: Mon, 5 Oct 2015 18:30:17 +0300
In-Reply-To: <1443168068-5719-1-git-send-email-nataraja@qti.qualcomm.com>
	(Vivek Natarajan's message of "Fri, 25 Sep 2015 13:31:08 +0530")
Message-ID: <87twq52v06.fsf@kamboji.qca.qualcomm.com> (sfid-20151005_173034_308549_45D0E3FF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <nataraja@qti.qualcomm.com> writes:

> The current number of spatial streams used by the client is advertised
> as a separate IE in assoc request. Use this information to set
> the NSS operating mode.
>
> Fixes: 45c9abc059fa ("ath10k: implement more versatile set_bitrate_mask").
> Signed-off-by: Vivek Natarajan <nataraja@qti.qualcomm.com>

This adds a new warning:

drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_peer_assoc_h_ht':
drivers/net/wireless/ath/ath10k/mac.c:2172:131: warning: comparison of distinct pointer types lacks a cast [enabled by default]
drivers/net/wireless/ath/ath10k/mac.c:2172:49: error: incompatible types in comparison expression (different type sizes)

-- 
Kalle Valo
