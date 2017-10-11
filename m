Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54454 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756656AbdJKIih (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 04:38:37 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com
Subject: Re: pull-request: iwlwifi-next 2017-10-06-2
References: <1507293175.908.134.camel@coelho.fi>
Date: Wed, 11 Oct 2017 11:38:28 +0300
In-Reply-To: <1507293175.908.134.camel@coelho.fi> (Luca Coelho's message of
        "Fri, 06 Oct 2017 15:32:55 +0300")
Message-ID: <87sheqqdtn.fsf@kamboji.qca.qualcomm.com> (sfid-20171011_103843_474152_3555A257)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here's the second version of my first pull-request intended for
> v4.15.  It contains the last two patch sets I sent out with v2 of the
> pci dump patch.
>
> In v2 we have fixed a potential kernel oops when our driver is used
> with qemu, for instance.  In that case, the root port is NULL and we
> were trying to access it without checing.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit a7c9acc452b21b56c99dd7dfe0ab542f7baa6563:
>
>   brcmfmac: Delete redundant length check (2017-10-02 17:07:00 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2017-10-06-2
>
> for you to fetch changes up to f2abcfa6c86e503b352846ace9d6ab9b02ade0ab:
>
>   iwlwifi: remove dflt_pwr_limit from the transport (2017-10-06 15:22:34 +0300)
>
> ----------------------------------------------------------------
> First batch of iwlwifi patches for 4.15 (v2)
>
> * Cleanups: - remove an unused value that we read from the NVM;
>             - remove link quality measurement code that was never used;
> * One FW command API update;
> * A fix and an addition for PCI devices for the A000 family;
> * Tiny refactor of ref/unref code used by runtime-PM;
> * Some debugging improvements;
> * Implementation of a more flexible way to define command queue sizes;
> * ACPI code refactoring;
> * Some coding-style fixes;
> * Avoid redundant command to the firmware;
> * Add a struct with the format of one FW command;
> * Change an error log to a warning when the FW API is not aligned with
>   the driver (important during development);
> * Change a WARN_ON to WARN_ONCE to make it more descriptive and less
>   noisy (i.e. no repeated warnings on a firmware triggered error);
> * Dump PCI registers when an error occurs, to make it easier to debug;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
