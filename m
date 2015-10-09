Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47875 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933867AbbJIIfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 04:35:11 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <c_mkenna@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Increase pci wakeup timeout to 30 ms
References: <1443104640-13965-1-git-send-email-c_mkenna@qti.qualcomm.com>
Date: Fri, 9 Oct 2015 11:34:53 +0300
In-Reply-To: <1443104640-13965-1-git-send-email-c_mkenna@qti.qualcomm.com> (c.
	mkenna's message of "Thu, 24 Sep 2015 19:54:00 +0530")
Message-ID: <87lhbcsamq.fsf@kamboji.qca.qualcomm.com> (sfid-20151009_103516_798867_A5C8E558)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<c_mkenna@qti.qualcomm.com> writes:

> From: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
>
> It is noticed that pci wakeup time is exceeding current timeout (10ms)
> randomly which is tested on QCA988x. So, the wake up time is increased
> to 30 ms and added debug prints to log total timeout.
>
> Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo
