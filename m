Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:28511 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbAMOTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 09:19:15 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fill max_num_vdevs for wmi-tlv
References: <1420713416-14634-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 13 Jan 2015 16:19:01 +0200
In-Reply-To: <1420713416-14634-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 8 Jan 2015 11:36:56 +0100")
Message-ID: <87h9vu69wq.fsf@kamboji.qca.qualcomm.com> (sfid-20150113_151918_252456_853DB1D8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Recent commit
> 30c78167bc6536d9074aa79385a575596343bf69 ("ath10k:
> set max_num_vdevs based on wmi op version")
> skipped wmi-tlv case and left max_num_vdevs reset.
> Make sure it is properly set.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
