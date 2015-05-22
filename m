Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:65401 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964813AbbEVKqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 06:46:45 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add new 4addr related fw_feature
References: <1432037374-26339-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 22 May 2015 13:46:33 +0300
In-Reply-To: <1432037374-26339-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 19 May 2015 14:09:34 +0200")
Message-ID: <874mn46gae.fsf@kamboji.qca.qualcomm.com> (sfid-20150522_124651_861751_CC68022B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Some firmware revisions pad 4th hw address in
> Native Wifi Rx decap. This is the case with 10.x
> and it was assumed that this is true for all
> firmware images.
>
> However QCA988X with 999.999.0.636 and QCA61X4
> with WLAN.RM.2.0-00088 don't have the padding.
> Hence add a feature flag indicating that the
> padding isn't present so firmware images can
> advertise it appropriately. This way driver will
> behave as it was before with old firmware blobs
> and doesn't cause any regressions from user
> perspective.
>
> Effectively this patch enables QCA988X with
> 999.999.0.636 and QCA61X4 with WLAN.RM.2.0-00088
> to set up client bridging provided user has an
> updated firmware blob.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
