Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51532 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756265AbeDXKBQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 06:01:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, janet.morgan@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2018-04-20
References: <92c9f150ac2ef6cf7fcf48f153eab9c4c7205804.camel@coelho.fi>
Date: Tue, 24 Apr 2018 13:01:10 +0300
In-Reply-To: <92c9f150ac2ef6cf7fcf48f153eab9c4c7205804.camel@coelho.fi> (Luca
        Coelho's message of "Fri, 20 Apr 2018 11:59:03 +0300")
Message-ID: <87in8gc49l.fsf@kamboji.qca.qualcomm.com> (sfid-20180424_120120_711400_6E4DDFC1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> This is the first batch of patches intended for v4.18 (or whatever
> Linus turns out to call it ;).  Nothing major here, just the usual
> continued development, bugfixes, new FW APIs and some new
> features.  More details about the contents in the tag description.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 5d1365940a68dd57b031b6e3c07d7d451cd69daf:
>
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2018-04-12 11:09:05 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2018-04-20
>
> for you to fetch changes up to bd8f3fc613919b50038c949f80b3f350a166293e:
>
>   iwlwifi: mvm: support 22000 HW opening agg before traffic (2018-04-20 10:57:16 +0300)
>
> ----------------------------------------------------------------
> iwlwifi patches for 4.18
>
> * implement Traffic Condition Monitor;
> * use TCM for scan and BT coex;
> * use TCM to detect when the AP doesn't support UAPSD properly;
> * some more work for the 22000 family of devices;
> * introduce AMSDU rate control offload;
> * a couple of clean-ups and bugfixes.
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
