Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49777 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbbKQNxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 08:53:08 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2015-11-15
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8EAF98@hasmsx107.ger.corp.intel.com>
Date: Tue, 17 Nov 2015 15:52:59 +0200
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8EAF98@hasmsx107.ger.corp.intel.com>
	(Emmanuel Grumbach's message of "Sun, 15 Nov 2015 19:30:30 +0000")
Message-ID: <87si44ybpg.fsf@kamboji.qca.qualcomm.com> (sfid-20151117_145328_097530_F0D14DE8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> Hi Kalle,
>
> Here is the first pull request for 4.4. I admit that the FW API is
> borderline but since we are very early in the cycle, I think it is fine.
> The firmware is far from being released yet (so that this patch doesn't
> change much now), but having this patch in will allow me to provide the
> new firmware to the 4.4 users.
> Along with that various bug fixes, a fix for a NULL pointer exception
> other things as explained in the tag.
>
> Please pull - thanks!
>
>
> The following changes since commit a493bcf8d6caf28f062c5f8f2ba486fdbf1ae899:
>
>   Merge tag 'wireless-drivers-next-for-davem-2015-10-29' of
> git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next (2015-10-30
> 20:38:24 +0900)
>
> are available in the git repository at:
>
>  
> https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2015-11-15
>
> for you to fetch changes up to 9513c5e18a0dc55a1fc9c890715098ba2315830b:
>
>   iwlwifi: mvm: Avoid dereferencing sta if it was already flushed
> (2015-11-15 21:18:01 +0200)
>
> ----------------------------------------------------------------
> * bump API to firmware 19 - not released yet.
> * fix D3 flows (Luca)
> * new device IDs (Oren)
> * fix NULL pointer dereference (Avri)
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
