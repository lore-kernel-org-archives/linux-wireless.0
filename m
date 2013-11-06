Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:16304 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab3KFNI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 08:08:56 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH/RFT 04/12] ath10k: rename function to match it's role
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
	<1383133346-8135-5-git-send-email-michal.kazior@tieto.com>
Date: Wed, 6 Nov 2013 15:08:49 +0200
In-Reply-To: <1383133346-8135-5-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 30 Oct 2013 12:42:18 +0100")
Message-ID: <87wqklr82m.fsf@kamboji.qca.qualcomm.com> (sfid-20131106_140859_100905_35C26D99)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> What the function does is to actually wait for the
> firmware indication bit to be set. Prerequisite
> for this is having interrupts registered.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

I think the title could be a bit more specific, like "ath10k: rename
ath10k_pci_reset_target()" or something like that.

-- 
Kalle Valo
