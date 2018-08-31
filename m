Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58064 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727513AbeHaTOu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 15:14:50 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2018-08-31
References: <ffddd3d6188213b090659d13dc216fe483f6c8ea.camel@coelho.fi>
Date: Fri, 31 Aug 2018 18:06:50 +0300
In-Reply-To: <ffddd3d6188213b090659d13dc216fe483f6c8ea.camel@coelho.fi> (Luca
        Coelho's message of "Fri, 31 Aug 2018 11:50:14 +0300")
Message-ID: <877ek6bmnp.fsf@kamboji.qca.qualcomm.com> (sfid-20180831_170737_396732_91554855)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Hi Kalle,
>
> This is first batch of patches intended for v4.20.  This includes the
> last 3 patchsets I sent.  Usual development work, with focus on HE and
> bugfixes, and some other small fixes and improvements.  More details
> about the contents in the tag description.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 9cac6a9b629739537d7792898cc0d401ae020205:
>
>   Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2018-08-28 19:39:22 +0300)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2018-08-31
>
> for you to fetch changes up to ab27926d9e4ae23df4f4d98e31f067c8b486bb4f:
>
>   iwlwifi: fix devices with PCI Device ID 0x34F0 and 11ac RF modules (2018-08-31 11:38:42 +0300)
>
> ----------------------------------------------------------------
> iwlwifi patches for 4.20
>
> * One fix for channel-switch handling;
> * Some improvements in the HE code;
> * New FW API handling;
> * Improvements in the debugging code;
> * Some improvements in the PCI recovery mechanism;
> * Support for a few FW API changes;
> * Enable a new scanning feature;
> * Continued work on HE (mostly radiotap);
> * Some fixes in the FW rate-scaling implementation;
> * Other clean-ups and small fixes and improvements;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
