Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14852 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbbCJP7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 11:59:31 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, Matthias Kaehlcke <mka@google.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath10k: Fix interpretation of cooling device state
References: <1425715380-11200-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Tue, 10 Mar 2015 17:59:19 +0200
In-Reply-To: <1425715380-11200-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Sat, 7 Mar 2015 13:32:57 +0530")
Message-ID: <87d24gyhbc.fsf@kamboji.qca.qualcomm.com> (sfid-20150310_165934_410296_914258B5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Setting the sysfs attribute ends up configuring the duty cycle,
> but the interface through which the attribute is exposed
> (cooling_device) is for setting the throttle/cooling state. This
> is confusing the user. Hence renaming the cooling device interfaces
> for better readability.
>
> Cc: Matthias Kaehlcke <mka@google.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

The four patches don't apply for some reason, please rebase.

-- 
Kalle Valo
