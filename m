Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48103 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaEWIci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 04:32:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Luca Coelho <luca@coelho.fi>
CC: <ath10k@lists.infradead.org>, <ath9k-devel@venema.h4ckr.net>,
	<linux-wireless@vger.kernel.org>, <michal.kazior@tieto.com>
Subject: Re: [PATCH] ath9k/ath10k: remove unnecessary channel_switch_beacon callbacks
References: <1400248534-16763-1-git-send-email-luca@coelho.fi>
Date: Fri, 23 May 2014 11:32:30 +0300
In-Reply-To: <1400248534-16763-1-git-send-email-luca@coelho.fi> (Luca Coelho's
	message of "Fri, 16 May 2014 16:55:34 +0300")
Message-ID: <87fvk0vqsh.fsf@kamboji.qca.qualcomm.com> (sfid-20140523_103244_506361_D591294D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Luciano Coelho <luciano.coelho@intel.com>
>
> The channel_switch_beacon callback is optional, so it doesn't have to
> be defined if it's not going to do anything useful with it.  Both
> ath9k and ath10k define the callback and just returns.  This commit
> removes them.
>
> Cc: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>

Thanks, applied.

-- 
Kalle Valo
