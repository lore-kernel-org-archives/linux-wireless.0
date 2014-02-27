Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55546 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaB0QlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 11:41:24 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: bitrate_mask add force_sgi support
References: <1389985454-3997-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Thu, 27 Feb 2014 18:41:18 +0200
In-Reply-To: <1389985454-3997-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Fri, 17 Jan 2014 20:04:14 +0100")
Message-ID: <87ha7kecep.fsf@kamboji.qca.qualcomm.com> (sfid-20140227_174133_463918_96A874D4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Add force SGI support.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
> depends on, nl80211: add Guard Interval support for set_bitrate_mask

Thanks. The dependency patch is now in ath-next and I have applied this
patch.

-- 
Kalle Valo
