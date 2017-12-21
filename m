Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:54313 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751381AbdLUN5f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 08:57:35 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rakesh Pillai <pillair@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3] Core changes for wcn3990
Date: Thu, 21 Dec 2017 13:57:26 +0000
Message-ID: <87tvwkchfe.fsf@kamboji.qca.qualcomm.com> (sfid-20171221_145740_776536_7859E0C7)
References: <1513854887-10759-1-git-send-email-pillair@qti.qualcomm.com>
In-Reply-To: <1513854887-10759-1-git-send-email-pillair@qti.qualcomm.com>
        (Rakesh Pillai's message of "Thu, 21 Dec 2017 16:44:44 +0530")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rakesh Pillai <pillair@qti.qualcomm.com> writes:

> This patchset includes the core changes for wcn3990 to
> - Add SNOC bus type used for wcn3990 target
> - Add the debug mask for SNOC bus type
> - Adding fw feature flag for non-bmi firmware load, since wcn3990
>   firmware is not loaded by bmi
>
> Govind Singh (2):
>   ath10k: Add SNOC bus type for WCN3990 target
>   ath10k: Add debug mask for SNOC bus type
>
> Rakesh Pillai (1):
>   ath10k: Add fw feature flag for non-bmi firmware load

What did you use as the baseline for these patches? While I was trying
to get these to the pending branch for build testing I noticed they
don't apply to any of ath.git branches and git can't even find the
baseline sha1 information:

$ git am -s -3 10127467.mbox
Applying: ath10k: Add SNOC bus type for WCN3990 target
Applying: ath10k: Add debug mask for SNOC bus type
Applying: ath10k: Add fw feature flag for non-bmi firmware load
fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath=
10k/core.c).
error: could not build fake ancestor
Patch failed at 0003 ath10k: Add fw feature flag for non-bmi firmware load
The copy of the patch that failed is found in: .git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

--=20
Kalle Valo=
