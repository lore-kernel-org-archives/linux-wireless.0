Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40052 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515AbcGKS5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 14:57:03 -0400
Date: Mon, 11 Jul 2016 14:57:00 -0400
From: Kyle McMartin <kyle@infradead.org>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-firmware@kernel.org
Subject: Re: pull request: new firmware files for all mvm wireless devices
Message-ID: <20160711185700.GH8680@merlin.infradead.org> (sfid-20160711_205709_021056_4276B23D)
References: <1468164649.8394.3.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468164649.8394.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 10, 2016 at 03:30:49PM +0000, Grumbach, Emmanuel wrote:
> Hi Kyle,
> 
> Intel is releasing new firmware versions for all its mvm wireless
> devices.
> For devices 7260, 7265 and 3160, this is the last firmware updates. We
> may still have critical bug fixes, but those won't get any new major
> releases. They will stay with -17.ucode.
> For 7265D and up, we release here the -22.ucode version.
> 
> Please pull.
> 
> Thanks!
> 
> The following changes since commit a14150061388f4bcbf3c3499f1b12e3f0d5c0e7b:
> 
>   linux-firmware: Fix the filename for WsP to align with device HW_VARIANT (2016-07-08 18:07:02 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git tags/iwlwifi-fw-2016-07-10

Pulled, thanks Emmanuel.

regards, --Kyle

> 
> for you to fetch changes up to b224bd0c77370a58b996a7be2c322b9fb4849398:
> 
>   iwlwifi: add new -22 firmware for 7265D and up (2016-07-10 09:41:14 +0300)
> 
> ----------------------------------------------------------------
> Release -21.ucode for 7265D and up
> Release -17.ucode for 7260 / 7265 and 3160
> 
> ----------------------------------------------------------------
> Emmanuel Grumbach (2):
>       iwlwifi: add new -17 firmware for iwlmvm devices
>       iwlwifi: add new -22 firmware for 7265D and up
> 
>  WHENCE                 |  24 ++++++++++++++++++++++++
>  iwlwifi-3160-17.ucode  | Bin 0 -> 918268 bytes
>  iwlwifi-3168-22.ucode  | Bin 0 -> 1028032 bytes
>  iwlwifi-7260-17.ucode  | Bin 0 -> 1049340 bytes
>  iwlwifi-7265-17.ucode  | Bin 0 -> 1180412 bytes
>  iwlwifi-7265D-17.ucode | Bin 0 -> 1383604 bytes
>  iwlwifi-7265D-22.ucode | Bin 0 -> 1028316 bytes
>  iwlwifi-8000C-22.ucode | Bin 0 -> 2120860 bytes
>  iwlwifi-8265-22.ucode  | Bin 0 -> 1811984 bytes
>  9 files changed, 24 insertions(+)
>  create mode 100644 iwlwifi-3160-17.ucode
>  create mode 100644 iwlwifi-3168-22.ucode
>  create mode 100644 iwlwifi-7260-17.ucode
>  create mode 100644 iwlwifi-7265-17.ucode
>  create mode 100644 iwlwifi-7265D-17.ucode
>  create mode 100644 iwlwifi-7265D-22.ucode
>  create mode 100644 iwlwifi-8000C-22.ucode
>  create mode 100644 iwlwifi-8265-22.ucode
> 
> diff --git a/WHENCE b/WHENCE
> index c3d98f6..4c41f21 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -848,6 +848,9 @@ Version: 25.30.13.0
>  File: iwlwifi-7260-16.ucode
>  Version 16.242414.0
>  
> +File: iwlwifi-7260-17.ucode
> +Version 17.352738.0
> +
>  File: iwlwifi-3160-7.ucode
>  Version: 22.1.7.0
>  
> @@ -869,6 +872,9 @@ Version: 25.30.13.0
>  File: iwlwifi-3160-16.ucode
>  Version 16.242414.0
>  
> +File: iwlwifi-3160-17.ucode
> +Version 17.352738.0
> +
>  File: iwlwifi-7265-8.ucode
>  Version: 22.24.8.0
>  
> @@ -887,6 +893,9 @@ Version: 25.30.13.0
>  File: iwlwifi-7265-16.ucode
>  Version 16.242414.0
>  
> +File: iwlwifi-7265-17.ucode
> +Version 17.352738.0
> +
>  File: iwlwifi-7265D-10.ucode
>  Version: 23.15.10.0
>  
> @@ -899,12 +908,21 @@ Version: 25.30.13.0
>  File: iwlwifi-7265D-16.ucode
>  Version 16.242414.0
>  
> +File: iwlwifi-7265D-17.ucode
> +Version 17.352738.0
> +
>  File: iwlwifi-7265D-21.ucode
>  Version 21.302800.0
>  
> +File: iwlwifi-7265D-22.ucode
> +Version 22.361476.0
> +
>  File: iwlwifi-3168-21.ucode
>  Version 21.302800.0
>  
> +File: iwlwifi-3168-22.ucode
> +Version 22.361476.0
> +
>  File: iwlwifi-8000C-13.ucode
>  Version: 25.30.13.0
>  
> @@ -914,9 +932,15 @@ Version 16.242414.0
>  File: iwlwifi-8000C-21.ucode
>  Version 21.302800.0
>  
> +File: iwlwifi-8000C-22.ucode
> +Version 22.361476.0
> +
>  File: iwlwifi-8265-21.ucode
>  Version 21.302800.0
>  
> +File: iwlwifi-8265-22.ucode
> +Version 22.361476.0
> +
>  Licence: Redistributable. See LICENCE.iwlwifi_firmware for details
>  
>  Also available from http://wireless.kernel.org/en/users/Drivers/iwlwifi#Firmware
> diff --git a/iwlwifi-3160-17.ucode b/iwlwifi-3160-17.ucode
> new file mode 100644
> index 0000000..e58f715
> Binary files /dev/null and b/iwlwifi-3160-17.ucode differ
> diff --git a/iwlwifi-3168-22.ucode b/iwlwifi-3168-22.ucode
> new file mode 100644
> index 0000000..d969aed
> Binary files /dev/null and b/iwlwifi-3168-22.ucode differ
> diff --git a/iwlwifi-7260-17.ucode b/iwlwifi-7260-17.ucode
> new file mode 100644
> index 0000000..6f5d713
> Binary files /dev/null and b/iwlwifi-7260-17.ucode differ
> diff --git a/iwlwifi-7265-17.ucode b/iwlwifi-7265-17.ucode
> new file mode 100644
> index 0000000..f2bf30e
> Binary files /dev/null and b/iwlwifi-7265-17.ucode differ
> diff --git a/iwlwifi-7265D-17.ucode b/iwlwifi-7265D-17.ucode
> new file mode 100644
> index 0000000..66940c4
> Binary files /dev/null and b/iwlwifi-7265D-17.ucode differ
> diff --git a/iwlwifi-7265D-22.ucode b/iwlwifi-7265D-22.ucode
> new file mode 100644
> index 0000000..26ca1bd
> Binary files /dev/null and b/iwlwifi-7265D-22.ucode differ
> diff --git a/iwlwifi-8000C-22.ucode b/iwlwifi-8000C-22.ucode
> new file mode 100644
> index 0000000..93a828b
> Binary files /dev/null and b/iwlwifi-8000C-22.ucode differ
> diff --git a/iwlwifi-8265-22.ucode b/iwlwifi-8265-22.ucode
> new file mode 100644
> index 0000000..3dbeb83
> Binary files /dev/null and b/iwlwifi-8265-22.ucode differ
