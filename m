Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42130 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbIIJnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 05:43:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: fix beamformee VHT STS capability
References: <1441192820-8403-1-git-send-email-bartosz.markowski@tieto.com>
Date: Wed, 9 Sep 2015 12:42:58 +0300
In-Reply-To: <1441192820-8403-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Wed, 2 Sep 2015 13:20:19 +0200")
Message-ID: <87twr47wt9.fsf@kamboji.qca.qualcomm.com> (sfid-20150909_114314_806838_ACEEF4D6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> The VHT STS CAP shall be reported by firmware to host, like in case of
> QCA99x0. For QCA6174 hw family this isn't set for some reason.
> So for this particular chips, let's assume it has the ability to
> support VHT NDP in up to 4 STSs (which is true by the way).
>
> Change the published beamformee STS cap accordingly to 3 or to what
> the firmware reports.
>
> Assumption so far, it suppose to be the num_rf_chains-1, was
> completely wrong.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Thanks, both patches applied.

-- 
Kalle Valo
