Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:7444 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161347AbaJaAdu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 20:33:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] ath10k: speed up recovery
References: <1414488878-31561-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 31 Oct 2014 02:33:44 +0200
In-Reply-To: <1414488878-31561-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 28 Oct 2014 10:34:35 +0100")
Message-ID: <87h9yldqmv.fsf@kamboji.qca.qualcomm.com> (sfid-20141031_013354_305876_7BFD8E83)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Patch #1 fixes a bug I've found while testing
> patches #2 and #3. It's safe to cherry-pick it in
> case patches #2 and/or #3 aren't accepted or need
> a re-spin.
>
> I've mainly used patch #2 to test reset and
> recovery. It's pretty handy for (stress-)testing.
>
> Patch #3 should improve recovery speed in some
> cases. Notably when there's a long chain of WMI
> commands involved which take a painfully long time
> to timeout/complete if firmware crashes mid-way.
>
> Note: Patches #2 and #3 depend on `ath10k: pci
> related fixes 2014-10-09`. Without the patchset
> patches #2 and #3 must not be applied. Patch #1 is
> fine though.
>
> v3:
>  * skip shadow ring cleanup in #1
>
> Michal Kazior (3):
>   ath10k: fix possible bmi crash
>   ath10k: expose hw restart via debugfs
>   ath10k: speed up hw recovery

Thanks, all three patches applied.

-- 
Kalle Valo
