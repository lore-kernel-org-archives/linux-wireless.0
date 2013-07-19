Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:39663 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760121Ab3GSKc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 06:32:57 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] ath10k: hardware recovery
References: <1372148011-28234-1-git-send-email-michal.kazior@tieto.com>
	<1373961277-14784-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 19 Jul 2013 13:32:48 +0300
In-Reply-To: <1373961277-14784-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 16 Jul 2013 09:54:34 +0200")
Message-ID: <87vc464z73.fsf@kamboji.qca.qualcomm.com> (sfid-20130719_123302_433243_51A53DED)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Respin of hw recovery. This implements recovery
> from a firmware crash.
>
> Note: this is based on my
>       "ath10k: device setup refactor" patchset.
>
> v3:
>  * rename RESTARTING_ON/OFF to RESTARTING/RESTARTED
>  * update commit message for 'create debufs..'
>
> Michal Kazior (3):
>   ath10k: implement device recovery
>   ath10k: implement fw crash simulation command
>   ath10k: create debugfs interface to trigger fw crash

Thanks, applied patches 1-2 and dropped patch 3.

-- 
Kalle Valo
