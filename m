Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58598 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932076AbeE3TSn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 15:18:43 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2018-05-30
References: <259624aff894846a91f47a5fd3758dc97566a1e3.camel@coelho.fi>
Date: Wed, 30 May 2018 22:18:37 +0300
In-Reply-To: <259624aff894846a91f47a5fd3758dc97566a1e3.camel@coelho.fi> (Luca
        Coelho's message of "Wed, 30 May 2018 16:33:09 +0300")
Message-ID: <87o9gx0x6a.fsf@kamboji.qca.qualcomm.com> (sfid-20180530_211852_567859_7DBEE02D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Hi Kalle,
>
> This is the final batch of patches intended for v4.18.  As discussed,
> it is focused on bugfixes.  More details about the contents in the tag
> description.
>
> I have sent this out before and kbuildbot this morning, but I didn't
> get any replies from it yet.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 06895b1627fe36f0bea49d4c9fd0e27f0f7498b1:
>
>   rtlwifi: remove duplicate code (2018-05-29 10:28:24 +0300)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2018-05-30
>
> for you to fetch changes up to 506247825c5e877741f33a2c657d351e5c7943ba:
>
>   iwlwifi: fix non_shared_ant for 9000 devices (2018-05-30 10:05:12 +0300)
>
> ----------------------------------------------------------------
> Final batch of iwlwifi patches for 4.18
>
> * Some bugzilla fixes;
> * Some kernel warning fixes;
> * Fix for an (ETSI) WMM limits bug;
> * Fix for a Bluetooth coexistence problem on 9000 devices;
> * Fix for an interoperability bug related to block-ack sessions;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
