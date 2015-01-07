Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:40579 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbbAGOdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 09:33:52 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix build error when hwmon is off
References: <1419420240-11208-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Wed, 7 Jan 2015 16:33:46 +0200
In-Reply-To: <1419420240-11208-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 24 Dec 2014 16:54:00 +0530")
Message-ID: <871tn6u0c5.fsf@kamboji.qca.qualcomm.com> (sfid-20150107_153357_311925_8B267410)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Place hwmon APIs inside CONFIG_HWMON switch to fix undefined
> errors when hwmon is not enabled.
>
> ERROR: "devm_hwmon_device_register_with_groups"
> [drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!
>
> Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thanks, but this has too many ifdefs for my taste. I have another idea,
let me send v2 shortly.

-- 
Kalle Valo
