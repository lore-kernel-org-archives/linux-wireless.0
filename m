Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51604 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdJTMvV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Oct 2017 08:51:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com
Subject: Re: pull-request: iwlwifi-next 2017-10-18
References: <1508322604.5497.156.camel@coelho.fi>
Date: Fri, 20 Oct 2017 15:51:16 +0300
In-Reply-To: <1508322604.5497.156.camel@coelho.fi> (Luca Coelho's message of
        "Wed, 18 Oct 2017 13:30:04 +0300")
Message-ID: <87vajadltn.fsf@kamboji.qca.qualcomm.com> (sfid-20171020_145126_481889_E80E0E1B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Hi Kalle,
>
> Here's the second batch of patches intended for v4.15.  It contains the
> last patch set I send out with v2 of the lq_color patch.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 66cc044249603e12e1dbba347f03bdbc9f171fdf:
>
>   bcma: use bcma_debug and pr_cont in MIPS driver (2017-10-17 17:22:07 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2017-10-18
>
> for you to fetch changes up to 3c798a45318e098e9937b0fee1e0cf986174fbbe:
>
>   iwlwifi: pcie: remove set but not used variable tcph (2017-10-18 13:02:01 +0300)
>
> ----------------------------------------------------------------
> Second batch of iwlwifi patches for 4.15
>
> * Allocate reorder buffer dynamically to save memory;
> * Fix a FW dump problem in the A000 family;
> * Fix for a statistics gathering issue (v2);
> * Sort the list of 9000 devices to make it easier to find entries;
> * A couple of cleanups in the FW dump code;
> * Remove some unnecessary variables and fields and calculations;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
