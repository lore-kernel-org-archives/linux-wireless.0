Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:5864 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaCXI0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 04:26:39 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: update regulatory domain settings for 10.x firmware
References: <1394797261-9219-1-git-send-email-marek.puzyniak@tieto.com>
Date: Mon, 24 Mar 2014 10:26:33 +0200
In-Reply-To: <1394797261-9219-1-git-send-email-marek.puzyniak@tieto.com>
	(Marek Puzyniak's message of "Fri, 14 Mar 2014 12:41:01 +0100")
Message-ID: <874n2o80jq.fsf@kamboji.qca.qualcomm.com> (sfid-20140324_092642_834809_B677C353)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> Regulatory domain settings for firmware 10.x has more options
> than main firmware, so handle regulatory domain setup separately
> for both supported firmwares. Fill in additional dfs domain
> parameter according to current regulatory.
> This patch does not solve any known bug. Not handled parameter
> for firmware 10.x was found during code review.
>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>

Thanks, applied.

-- 
Kalle Valo
