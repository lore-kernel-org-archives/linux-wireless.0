Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:54058 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbaJHKXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 06:23:44 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: advertise all possible firmware(-api) files
References: <1412597801-19298-1-git-send-email-bartosz.markowski@tieto.com>
Date: Wed, 8 Oct 2014 13:23:20 +0300
In-Reply-To: <1412597801-19298-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Mon, 6 Oct 2014 14:16:41 +0200")
Message-ID: <87siiyg8rr.fsf@kamboji.qca.qualcomm.com> (sfid-20141008_122348_668016_5B2069C6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> This is required if we take into account possibility to load the driver
> from initrd (RAM disk), so in other words: very early in the boot process,
> before the file system is visible.
>
> In such case we need to have the firmware files accessible from ram disk too,
> and this patch guarantee this.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, applied.

-- 
Kalle Valo
