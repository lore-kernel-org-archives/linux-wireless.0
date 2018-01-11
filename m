Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35128 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934499AbeAKQbL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jan 2018 11:31:11 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, janet.morgan@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-next 2017-12-20
References: <1513787503.4827.488.camel@coelho.fi>
Date: Thu, 11 Jan 2018 18:31:06 +0200
In-Reply-To: <1513787503.4827.488.camel@coelho.fi> (Luca Coelho's message of
        "Wed, 20 Dec 2017 18:31:43 +0200")
Message-ID: <87efmwtl11.fsf@kamboji.qca.qualcomm.com> (sfid-20180111_173116_124251_9750E0C9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> This is my third batch of patches intended for v4.16.  Nothing major
> here, just the usual continued development.  More details about the
> contents in the tag description.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit f39a5c01c3d24f2f61ec9d8c7d7e81f9aca506ce:
>
>   Merge branch 'nfp-flower-add-Geneve-tunnel-support' (2017-12-19 14:52:13 -0500)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2017-12-20
>
> for you to fetch changes up to 4243edb4704ed950a43440dfb4cbd5613db6ab6c:
>
>   iwlwifi: define and use if iwl_mvm_has_tlc_offload (2017-12-20 18:28:25 +0200)
>
> ----------------------------------------------------------------
> Third batch of updates for v4.16
>
> * Small cleanups in the new rate-scaling code;
> * Some improvements in debugging;
> * New FW API changes;
> * Fix a bug where we got a false-positive warning;
> * Fix forced quota debugfs functionality;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
