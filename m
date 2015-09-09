Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:49786 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbbIIJiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 05:38:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vivek Natarajan <nataraja@qti.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Drop probe responses when too many are queued
References: <1441019095-2364-1-git-send-email-nataraja@qti.qualcomm.com>
Date: Wed, 9 Sep 2015 12:37:57 +0300
In-Reply-To: <1441019095-2364-1-git-send-email-nataraja@qti.qualcomm.com>
	(Vivek Natarajan's message of "Mon, 31 Aug 2015 16:34:55 +0530")
Message-ID: <87y4gg7x1m.fsf@kamboji.qca.qualcomm.com> (sfid-20150909_113814_026154_7E9E8258)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <nataraja@qti.qualcomm.com> writes:

> In a noisy environment, when multiple interfaces are created,
> the management tx descriptors are fully occupied by the probe
> responses from all the interfaces. This prevents a new station
> from a successful association.
>
> Fix this by limiting the probe responses when the specified
> threshold limit is reached.
>
> Signed-off-by: Vivek Natarajan <nataraja@qti.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
