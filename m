Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51569 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbbBDHX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 02:23:26 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: enable qca6174 hw3.2
References: <1422534273-18427-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 4 Feb 2015 09:23:16 +0200
In-Reply-To: <1422534273-18427-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 29 Jan 2015 13:24:33 +0100")
Message-ID: <87wq3yuom3.fsf@kamboji.qca.qualcomm.com> (sfid-20150204_082358_740475_9BF199EE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The 3.2 revision has a different target BMI
> version so it wasn't recognized by ath10k (despite
> the chip_id rev being on the supported list
> already).
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
