Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40132 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750723AbdGYFgl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 01:36:41 -0400
Message-ID: <1500960997.20057.39.camel@coelho.fi> (sfid-20170725_073647_974974_061BE2BE)
From: Luca Coelho <luca@coelho.fi>
To: Kyle McMartin <kyle@infradead.org>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>,
        linux-firmware@kernel.org,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Date: Tue, 25 Jul 2017 08:36:37 +0300
In-Reply-To: <1498578162.22048.77.camel@coelho.fi>
References: <1498578162.22048.77.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi firmwares update 2017-06-27
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping?

On Tue, 2017-06-27 at 18:42 +0300, Luca Coelho wrote:
> Hi Kyle,
> 
> We have some updates for our -27 firmware version (on supported devices)
> and versions -29 and -31 that will be supported by the iwlwifi driver on
> v4.13.
> 
> Please pull or let me know if there are any issues.
> 
> Cheers,
> Luca.
> 
> 
> The following changes since commit 7d2c913dcd1be083350d97a8cb1eba24cfacbc8a:
> 
>   ath10k: update year in license (2017-06-22 12:06:02 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git tags/iwlwifi-fw-2017-06-27
> 
> for you to fetch changes up to d392df8feda805e37022686d76be96de407a9e18:
> 
>   iwlwifi: add new firmware for 3168, 7265D, 8000C and 8265 (2017-06-27 14:45:20 +0300)
> 
> ----------------------------------------------------------------
> Update and add new firmwares for 3168, 7265D, 8000C and 8265
> 
> * new -29 for 3168 and 7265D;
> * new -31 for 8000C and 8265;
> * updated -27 for 3168, 7265D, 8000C and 8265.
> 
> ----------------------------------------------------------------
> Emmanuel Grumbach (1):
>       iwlwifi: update -27 firmware for 3168, 7265D, 8000C and 8265
> 
> Johannes Berg (1):
>       iwlwifi: add new firmware for 3168, 7265D, 8000C and 8265
> 
>  WHENCE                 |  20 ++++++++++++++++----
>  iwlwifi-3168-27.ucode  | Bin 1032168 -> 1032436 bytes
>  iwlwifi-3168-29.ucode  | Bin 0 -> 1036372 bytes
>  iwlwifi-7265D-27.ucode | Bin 1032452 -> 1032740 bytes
>  iwlwifi-7265D-29.ucode | Bin 0 -> 1036528 bytes
>  iwlwifi-8000C-27.ucode | Bin 2227284 -> 2227284 bytes
>  iwlwifi-8000C-31.ucode | Bin 0 -> 2309768 bytes
>  iwlwifi-8265-27.ucode  | Bin 2234528 -> 2234528 bytes
>  iwlwifi-8265-31.ucode  | Bin 0 -> 2303024 bytes
>  9 files changed, 16 insertions(+), 4 deletions(-)
>  create mode 100644 iwlwifi-3168-29.ucode
>  create mode 100644 iwlwifi-7265D-29.ucode
>  create mode 100644 iwlwifi-8000C-31.ucode
>  create mode 100644 iwlwifi-8265-31.ucode
