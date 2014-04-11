Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:25092 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaDKFZ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 01:25:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] ath10k: fix radar/cac
References: <1396337123-12622-1-git-send-email-michal.kazior@tieto.com>
	<1396610926-5787-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 11 Apr 2014 08:25:20 +0300
In-Reply-To: <1396610926-5787-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 4 Apr 2014 13:28:44 +0200")
Message-ID: <87bnw8h1z3.fsf@kamboji.qca.qualcomm.com> (sfid-20140411_072545_348824_CB3D29B0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This loosely depends on `ath10k: refactor monitor
> code`. Without it patch this patchset introduces
> some (harmless) runtime warnings.
>
> This v2 introduces a non-functional patch to avoid
> forward declaration. The [1/2] has a little
> conflict with `ath10k: refactor monitor code`
> which renames ath10k_monitor_stop() to
> ath10k_monitor_vdev_stop().
>
> Part of the original CAC problem is also addressed
> in `mac80211: fix radar_enabled propagation`.
>
>
> Michal Kazior (2):
>   ath10k: reorder functions
>   ath10k: refactor radar detection code

Thanks, both patches applied.

-- 
Kalle Valo
