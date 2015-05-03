Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40116 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbbECU4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 16:56:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2015-04-28
References: <1430224907.4748.3.camel@intel.com>
Date: Sun, 03 May 2015 23:56:28 +0300
In-Reply-To: <1430224907.4748.3.camel@intel.com> (Emmanuel Grumbach's message
	of "Tue, 28 Apr 2015 12:41:47 +0000")
Message-ID: <87y4l5wfb7.fsf@kamboji.qca.qualcomm.com> (sfid-20150503_225636_244770_FDC7F03E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> Here is the first round of fixes for 4.1.
> As usual, this first round is slightly big. I hope things will settle down later.
>
> Please pull. Thanks!
>
> The following changes since commit 6c373ca89399c5a3f7ef210ad8f63dc3437da345:
>
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2015-04-15 09:00:47 -0700)
>
> are available in the git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2015-04-28
>
> for you to fetch changes up to e7afe89fd67d40a7f5fff8130c5f925d99a94b1f:
>
>   iwlwifi: mvm: force quota update update after FW restart (2015-04-28 15:02:25 +0300)
>
> ----------------------------------------------------------------
> * fix firmware API for -13.ucode
> * fix RSSI handling that avoid bad roaming decision
> * fix firmware debug
> * fix MFUART operation
> * fix ASSERT while restart the hardware (because of another ASSERT e.g)
>
> ----------------------------------------------------------------

Thanks, pulled.

-- 
Kalle Valo
