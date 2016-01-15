Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:56814 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbcAOIAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2016 03:00:36 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <miaoqing@codeaurora.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 1/5] ath9k: avoid ANI restart if no trigger
References: <1452821009-1156-1-git-send-email-miaoqing@codeaurora.org>
	<1452821009-1156-2-git-send-email-miaoqing@codeaurora.org>
Date: Fri, 15 Jan 2016 10:00:17 +0200
In-Reply-To: <1452821009-1156-2-git-send-email-miaoqing@codeaurora.org>
	(miaoqing@codeaurora.org's message of "Fri, 15 Jan 2016 09:23:25
	+0800")
Message-ID: <871t9j8e7i.fsf@kamboji.qca.qualcomm.com> (sfid-20160115_090039_223872_10B4F791)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<miaoqing@codeaurora.org> writes:

> From: Miaoqing Pan <miaoqing@codeaurora.org>
>
> ath9k_ani_restart() is always be invoked even if the trigger
> condition is false.
>
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

Why? The commit log should always answer that.

-- 
Kalle Valo
