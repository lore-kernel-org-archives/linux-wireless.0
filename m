Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10608 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3FAMPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 08:15:19 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Sivanesan Rajapupathi <c_srajap@qti.qualcomm.com>,
	<ath6kl-devel@qca.qualcomm.com>
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: Re: [PATCH 1/2] ath6kl: Rename USB driver's suspend/resume/reset_resume
References: <1368593530-3568-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Sat, 1 Jun 2013 15:15:14 +0300
In-Reply-To: <1368593530-3568-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Wed, 15 May 2013 10:22:10
	+0530")
Message-ID: <87k3meni25.fsf@kamboji.qca.qualcomm.com> (sfid-20130601_141522_484083_93FBF4B9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> Rename USB driver's suspend/resume/reset_resume callbacks
> with 'pm' prefix. This is necessary to differentiate it from
> cfg80211/hif suspend/resume/reset_resume callbacks.
>
> Cc: Sivanesan Rajapupathi <c_srajap@qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Thanks, both applied.

-- 
Kalle Valo
