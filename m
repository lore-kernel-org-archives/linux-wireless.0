Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47498 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbbLRNFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 08:05:07 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2015-12-16
References: <0BA3FCBA62E2DC44AF3030971E174FB32E91F275@hasmsx107.ger.corp.intel.com>
Date: Fri, 18 Dec 2015 15:04:58 +0200
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E91F275@hasmsx107.ger.corp.intel.com>
	(Emmanuel Grumbach's message of "Wed, 16 Dec 2015 08:15:09 +0000")
Message-ID: <87vb7vaow5.fsf@kamboji.qca.qualcomm.com> (sfid-20151218_140512_612135_460DC891)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> This is a pull request with small fixes for 4.4.
> Note that due to the large number of files being renamed, you need to
> set merge.renameLimit to a big number to merge wl-drv into wl-drv-next
> but you probably noticed that already :)
>
> The following changes since commit 9513c5e18a0dc55a1fc9c890715098ba2315830b:
>
>   iwlwifi: mvm: Avoid dereferencing sta if it was already flushed
> (2015-11-15 21:18:01 +0200)
>
> are available in the git repository at:
>
>  
> https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2015-12-16

Pulled, thanks.

-- 
Kalle Valo
