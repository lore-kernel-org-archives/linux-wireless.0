Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49608 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbcATMm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 07:42:56 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Andreas Kemnade <andreas@kemnade.info>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, hns@goldelico.com
Subject: Re: [PATCH RFC] wireless:libertas: enable auto deep sleep
References: <1453275709-25276-1-git-send-email-andreas@kemnade.info>
Date: Wed, 20 Jan 2016 14:42:47 +0200
In-Reply-To: <1453275709-25276-1-git-send-email-andreas@kemnade.info> (Andreas
	Kemnade's message of "Wed, 20 Jan 2016 08:41:49 +0100")
Message-ID: <87lh7k2zi0.fsf@kamboji.qca.qualcomm.com> (sfid-20160120_134314_661842_BB119D00)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andreas Kemnade <andreas@kemnade.info> writes:

> Enables auto deep sleep whenever the interface is up and
> power managament is enabled, so there is also power management
> when there is no connection
> That reduces power consumption between scanning
> intervals. Deep sleep mode is entered when there is
> no activity for 1s.
>
> The code looks a bit different to how things were done
> with the wext interface in earlier times.
>
> Signed-off-by: Andreas Kemnade <andreas@kemnade.info>

Please use just "libertas: " as the prefix and drop the "wireless:".

-- 
Kalle Valo
