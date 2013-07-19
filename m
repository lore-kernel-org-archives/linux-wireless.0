Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:50630 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab3GSKSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 06:18:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 00/10] ath10k: device setup refactor
References: <1371041642-20273-1-git-send-email-michal.kazior@tieto.com>
	<1373960339-8525-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 19 Jul 2013 13:18:39 +0300
In-Reply-To: <1373960339-8525-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 16 Jul 2013 09:38:49 +0200")
Message-ID: <874nbq6ef4.fsf@kamboji.qca.qualcomm.com> (sfid-20130719_121902_700314_0ED09C58)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This is a respin of my patchset that addresses
> hibernation issues.
>
> This is also groundwork for proper hw recovery
> that I'm going to post too.
>
> v4:
>  * update comments in pci logic decoupling
>  * add missing commit message for one of the patches
>  * update commit message for free_vdev_map patch
>
> Michal Kazior (10):
>   ath10k: decouple pci start/stop logic
>   ath10k: decouple core start/stop logic
>   ath10k: allow deferred regd update
>   ath10k: reset BMI state upon init
>   ath10k: decouple suspend code
>   ath10k: move free_vdev_map initialization
>   ath10k: make sure all resources are freed upon ath10k_stop()
>   ath10k: defer hw setup to start/stop mac80211 hooks
>   ath10k: store firmware files in memory
>   ath10k: skip fw stats debugfs interface if device is down

Thanks, all 10 applied.

-- 
Kalle Valo
