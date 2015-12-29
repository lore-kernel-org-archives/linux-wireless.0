Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59046 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbbL2QrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2015 11:47:19 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next-2015-12-21
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Date: Tue, 29 Dec 2015 18:47:11 +0200
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
	(Emmanuel Grumbach's message of "Mon, 21 Dec 2015 20:48:59 +0000")
Message-ID: <87oad9qk1c.fsf@kamboji.qca.qualcomm.com> (sfid-20151229_174722_153795_EC4DFFB3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> Hi Kalle,
>
> here is a pull request for 4.5. I guess there will be one more after
> that depending on when Linus will open the merge window I guess. The
> diffstat look awful and I have no clue why. It looks as if I had done
> the whole code reorganisation... So we have a pretty large pull
> request here. We are facing big new things: a new device family with
> lots of work in the data path and such. Details in the tag. Let me
> know if you have issues. Note that as I said, I needed to merge
> Johannes's tree to get the new uAPSD helper I added and I merge
> iwlwifi-fixes.git to avoid conflicts.
>
> The following changes since commit 1b894521e60c1b91db1e8ba1278660e5c89f1b5f:
>
>   mac80211: handle HW ROC expired properly (2015-12-07 11:06:37 +0100)
>
> are available in the git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2015-12-21

Pulled, thanks. Happy New Year! 

-- 
Kalle Valo
