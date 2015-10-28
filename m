Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:12790 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbbJ1UXK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 16:23:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl@lists.infradead.org>
Subject: Re: [PATCH-v2 1/2] ath6k:  break stats gathering code into separate method.
In-Reply-To: <1445530059-6276-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Thu, 22 Oct 2015 09:07:38
	-0700")
References: <1445530059-6276-1-git-send-email-greearb@candelatech.com>
Date: Wed, 28 Oct 2015 22:09:46 +0200
Message-ID: <87eggesqk5.fsf@kamboji.qca.qualcomm.com> (sfid-20151028_212326_357221_28DFCE53)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> This will allow us to call it from elsewhere when implementing
> ethtool stats.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

I'll do s/ath6k/ath6kl/ (manually) for both patches.

-- 
Kalle Valo
