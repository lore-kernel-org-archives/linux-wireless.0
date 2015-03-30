Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:36943 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbbC3MT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 08:19:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/9] ath10k: cleanups 2015-03-20
References: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 30 Mar 2015 15:19:19 +0300
In-Reply-To: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 20 Mar 2015 13:54:06 +0000")
Message-ID: <87zj6u4r08.fsf@kamboji.qca.qualcomm.com> (sfid-20150330_141932_795672_D266A515)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Here's a bunch of cleanups and fixes associated
> with tx/rx rate code.
>
> Feel free to squash some of the patches if you
> think it makes sense or let me know which ones you
> want me to squash.
>
> There are a few checkpatch warnings for going over
> 80 chars. I decided to leave them be to avoid code
> wrapping which would make the code less readable
> than it is now in my opinion.
>
> I have 2 more patches for .set_bitrate_mask()
> callback which depend on this patchset. Once you
> apply this patchset to your `pending` branch let
> me know, please, so I can push the rest with git
> indexes your git repo will recognize.

Sorry, I had missed this comment and didn't realise to tell you when I
applied the patches to pending branch. The bad part with patchwork is
that it doesn't show the cover letter at all :(

> Michal Kazior (9):
>   ath10k: move rate definitions to file start
>   ath10k: derive rate from bitrate
>   ath10k: drop RATETAB_ENT macro
>   ath10k: add hw rate definitions
>   ath10k: use hw rate definitions for fixed rate
>   ath10k: simplify fixed rate selection
>   ath10k: rework legacy rx rate decoding
>   ath10k: deduplicate bitrate to rate idx conversion
>   ath10k: document ofdm/5ghz rate offset with a macro

Thanks, all patches applied.

-- 
Kalle Valo
