Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:12068 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbbCJPj4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 11:39:56 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath10k: add symlink for hwmon device
References: <1424437452-28161-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1424437452-28161-3-git-send-email-rmanohar@qti.qualcomm.com>
Date: Tue, 10 Mar 2015 17:39:46 +0200
In-Reply-To: <1424437452-28161-3-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Fri, 20 Feb 2015 18:34:12 +0530")
Message-ID: <87pp8gyi7x.fsf@kamboji.qca.qualcomm.com> (sfid-20150310_163959_531302_A09F4FE9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Add symbloic link "thermal_sensors" for hwmon devices for better
> readability.
>
> /sys/class/ieee80211/phyX/device/thermal_sensors ->
> sys/class/ieee80211/phyX/device/hwmon/hwmonY

I don't get it, how does that improve readability? Also I don't see any
other driver doing this, so isn't this just some private hack and not a
proper generic interface?

-- 
Kalle Valo
