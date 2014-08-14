Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:41982 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbaHNMSC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 08:18:02 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2] ath10k:  improve vdev map handling.
References: <1407260684-22624-1-git-send-email-greearb@candelatech.com>
Date: Thu, 14 Aug 2014 15:17:53 +0300
In-Reply-To: <1407260684-22624-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Tue, 5 Aug 2014 10:44:44
	-0700")
Message-ID: <87fvgzmfim.fsf@kamboji.qca.qualcomm.com> (sfid-20140814_141807_371804_C19B0A09)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Check vdev map has space before calling ffs,
> fix invalid cleanup in failure to create vdev
> case.
>
> Open-code the BIT() logic since BIT does not properly
> handle 64-bit bitfields and future patches will make
> use of larger bitfields.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Thanks, applied.

-- 
Kalle Valo
