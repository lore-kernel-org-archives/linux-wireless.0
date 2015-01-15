Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:22617 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbbAOKgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 05:36:24 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: document switch case fall-through in __ath10k_scan_finish
References: <1421096822-28698-1-git-send-email-linville@tuxdriver.com>
Date: Thu, 15 Jan 2015 12:36:15 +0200
In-Reply-To: <1421096822-28698-1-git-send-email-linville@tuxdriver.com> (John
	W. Linville's message of "Mon, 12 Jan 2015 16:07:02 -0500")
Message-ID: <87sifcxrds.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_113627_759239_233F16F7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> Add a comment for indicating that the ATH10K_SCAN_RUNNING case falls
> through to the ATH10K_SCAN_ABORTING case in __ath10k_scan_finish.  This
> will document that the lack of a break is intentional.
>
> Coverity: CID 1260017
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
