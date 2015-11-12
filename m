Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:14718 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbbKLTHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 14:07:51 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ryan Hsu <ryanhsu@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: Override CE5 configuration for QCA6147 device
References: <1446777867-5452-1-git-send-email-ryanhsu@qca.qualcomm.com>
Date: Thu, 12 Nov 2015 21:07:10 +0200
In-Reply-To: <1446777867-5452-1-git-send-email-ryanhsu@qca.qualcomm.com> (Ryan
	Hsu's message of "Thu, 5 Nov 2015 18:44:27 -0800")
Message-ID: <87ziyj595t.fsf@kamboji.qca.qualcomm.com> (sfid-20151112_200754_939769_660A83D4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ryan Hsu <ryanhsu@qca.qualcomm.com> writes:

> 'Commit a70587b3389a ("ath10k: configure copy engine 5 for HTT messages")'
> Introduces to use the unused CE5 for target to host message.
>
> For the device like QCA6174, CE5 already assigned for other feature.
> So for QCA6174, override the CE5 configuration and use the CE1 instead.
>
> This patch is based on Rajkumar's earlier patch.
>
> Fixes: a70587b3389a ("ath10k: configure copy engine 5 for HTT messages")
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> Signed-off-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>

Applied to ath-current, thanks.

-- 
Kalle Valo
