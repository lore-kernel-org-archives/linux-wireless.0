Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32872 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab3GENZv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:25:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH v2] ath10k: leave MMIC generation to the HW
References: <1372060350-31460-4-git-send-email-michal.kazior@tieto.com>
	<1372229844-7987-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 5 Jul 2013 16:25:41 +0300
In-Reply-To: <1372229844-7987-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 26 Jun 2013 08:57:24 +0200")
Message-ID: <87y59lf8a2.fsf@kamboji.qca.qualcomm.com> (sfid-20130705_152555_745934_9CB77E42)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Apparently HW doesn't require us to generate MMIC
> for TKIP suite.
>
> Each frame was 8 bytes longer than it should be
> and some APs would drop frames that exceed 1520
> bytes of 802.11 payload. This could be observed
> during throughput tests or fragmented IP traffic.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

This is also applied.

-- 
Kalle Valo
