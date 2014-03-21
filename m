Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:39824 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759462AbaCUOuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 10:50:00 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: separate result parameter in ath10k_bmi_execute()
References: <20140311153318.7148.47415.stgit@potku.adurom.net>
Date: Fri, 21 Mar 2014 16:49:54 +0200
In-Reply-To: <20140311153318.7148.47415.stgit@potku.adurom.net> (Kalle Valo's
	message of "Tue, 11 Mar 2014 17:33:19 +0200")
Message-ID: <87d2hfbo8d.fsf@kamboji.qca.qualcomm.com> (sfid-20140321_155009_122686_25413F92)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> It's just cleaner to have separate argument for the parameter and result. Also
> fix returned error value if response length is invalid.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Both patches applied.

-- 
Kalle Valo
