Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41502 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3ILQNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Sep 2013 12:13:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Calculate correct peer PHY mode for VHT
References: <20130908151955.9228.15022.stgit@localhost6.localdomain6>
Date: Thu, 12 Sep 2013 19:13:49 +0300
In-Reply-To: <20130908151955.9228.15022.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Sun, 08 Sep 2013 18:19:55 +0300")
Message-ID: <8761u6f26a.fsf@qca.qualcomm.com> (sfid-20130912_181354_912073_4FBC7D25)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> The peer PHY mode for 11ac operation needs to be determined
> properly based on the channel bandwidth being used. Fix
> this so that the proper mode is given to the firmware.
>
> kvalo: earlier we used 11na-ht20 in STA mode for 11ac AP peer, this
> patch changes that to 11ac-vht80. I didn't notice any change in
> throughput in my tests, but nevertheless it's the right thing
> to do.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied. Thanks Sujith.

-- 
Kalle Valo
