Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17214 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaBMPZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 10:25:16 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3] ath10k: reduce number of host corruptions
References: <1392048864-13352-1-git-send-email-marek.puzyniak@tieto.com>
Date: Thu, 13 Feb 2014 17:25:10 +0200
In-Reply-To: <1392048864-13352-1-git-send-email-marek.puzyniak@tieto.com>
	(Marek Puzyniak's message of "Mon, 10 Feb 2014 17:14:21 +0100")
Message-ID: <87d2ir827d.fsf@kamboji.qca.qualcomm.com> (sfid-20140213_162520_888570_ED87E476)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> This patchset reduces frequency of a strange HW bug
> in CUS232 boards.
>
> The bug happens in some workloads with different
> frequency with different hardware spinoffs. It is
> triggered by a cold reset after HW/FW has been
> excercised with some work. On x86 this could be a hang,
> on AP135 it is a data bus error. Frequency of problem
> is reduced in driver by calling first warm reset
> instead of cold reset. When warm reset fails then
> driver will call cold reset. 
>
> Marek Puzyniak (2):
>   ath10k: refactor suspend/resume functions
>   ath10k: suspend hardware before reset
>
> Michal Kazior (1):
>   ath10k: fix device initialization routine

Thanks, all three patches applied.

-- 
Kalle Valo
