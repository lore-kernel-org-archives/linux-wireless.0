Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:12617 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaJGOch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 10:32:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: add tracing for frame transmission
References: <1412615346-18010-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Tue, 7 Oct 2014 17:32:30 +0300
In-Reply-To: <1412615346-18010-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Mon, 6 Oct 2014 22:39:06 +0530")
Message-ID: <87lhoshrwh.fsf@kamboji.qca.qualcomm.com> (sfid-20141007_163241_382867_D826D1AF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Add tracing support to forward management and data frames to
> user space for packet inspection.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

My assumption is that this patch superseded the patches below. Please
let me know if I have misunderstood.

!  [  27: Rajkumar Manoharan     ] [PATCH 0/4] ath10k: Add tracing for tx and rx frames
!      [  70: Rajkumar Manoharan     ] [PATCH 1/4] ath10k: add tracepoint for wmi mgmt tx frames
!      [  68: Rajkumar Manoharan     ] [PATCH 2/4] ath10k: add tracepoint for wmi bcn tx
!      [  72: Rajkumar Manoharan     ] [PATCH 3/4] ath10k: add htt rx tracepoints
!      [  80: Rajkumar Manoharan     ] [PATCH 4/4] ath10k: add tracepoint for htt tx frames
!  [  80: Rajkumar Manoharan     ] [PATCH 1/2] ath10k: add tracepoint for htt tx frames
!      [ 105: Rajkumar Manoharan     ] [PATCH 2/2] ath10k: add tracing for frame transmission

For the future: it's a lot easier if you add a cover letter for the
patch series, keep the cover letter title unchanged and just increase
the version number after each revision. That way I can immeaditely see
what patches I should take or ignore.

-- 
Kalle Valo
