Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37417 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab3HONKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 09:10:23 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3] ath10k: firmware-related updates
References: <1375949298-7159-1-git-send-email-michal.kazior@tieto.com>
	<1376036014-29707-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 15 Aug 2013 16:09:01 +0300
In-Reply-To: <1376036014-29707-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 9 Aug 2013 10:13:31 +0200")
Message-ID: <87d2pf14pe.fsf@kamboji.qca.qualcomm.com> (sfid-20130815_151026_703249_67999B17)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This patchset contains 2 firmware-related upgrades
> and 1 fix (that I though is a good pick to include
> here, since it's related with HTT tx).
>
> This keeps backward compatbility with old
> firmware.
>
> This includes fixes for issues pointed out during
> RFC review.

[...]

> Michal Kazior (3):
>   ath10k: clean up HTT tx tid handling

I dropped this patch.

>   ath10k: add support for firmware newer than 636
>   ath10k: add support for HTT 3.0

These two are applied.

-- 
Kalle Valo
