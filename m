Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53918 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbcCGNu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 08:50:57 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next 2016-03-02
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Date: Mon, 07 Mar 2016 15:50:49 +0200
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
	(Emmanuel Grumbach's message of "Wed, 2 Mar 2016 07:51:12 +0000")
Message-ID: <87r3fms8g6.fsf@kamboji.qca.qualcomm.com> (sfid-20160307_145100_430819_E5CD78F3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> This is a pull request for 4.6. It is big because a lot of patches were
> waiting for code in mac80211-next which is now in net-next.
> As you figured, I need you to pull Johannes's 
> mac80211-next-for-davem-2016-02-26 before you pull this from me.
> Of course, you can just merge net-next. This is really up to you :)
> I also merged iwlwifi-fixes.git (twice even) to prevent conflicts upstream.
> In the tag, I mentioned which patches need mac80211-next since you asked for it
> last time.
>
> My prevent_stupid_mistakes.sh script seems to be working fairly well now,
> in case you see an issue, let me know.
>
> Thanks!
>
>
> The following changes since commit 50ee738d7271fe825e4024cdfa5c5301a871e2c2:
>
>   rfkill: Add documentation about LED triggers (2016-02-24 09:13:12 +0100)
>
> are available in the git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2016-03-02

Pulled, thanks.

-- 
Kalle Valo
