Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:26467 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbbAOKhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 05:37:07 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix hwmon temperature input units
References: <1421128207-28641-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Thu, 15 Jan 2015 12:36:53 +0200
In-Reply-To: <1421128207-28641-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Tue, 13 Jan 2015 11:20:07 +0530")
Message-ID: <87oaq0xrcq.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_113712_098345_A1BA10E2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> To be compliant with the hwmon interface the unit needs to be
> millidegree Celsius. Fix that.
>
> Reported-by: Matthias Kaehlcke <mka@google.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
