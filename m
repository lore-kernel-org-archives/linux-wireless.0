Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59762 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162795AbbKTQfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 11:35:05 -0500
Date: Fri, 20 Nov 2015 11:35:02 -0500
From: Kyle McMartin <kyle@infradead.org>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhao, Yingying" <yingying.zhao@intel.com>,
	"Guo, Chaohong" <chaohong.guo@intel.com>, linux-firmware@kernel.org
Subject: Re: pull request: iwlwifi firmware for iwlmvm devices
Message-ID: <20151120163502.GE27752@merlin.infradead.org> (sfid-20151120_173512_944728_B71C89A4)
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8F0C94@hasmsx107.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8F0C94@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2015 at 08:10:11AM +0000, Grumbach, Emmanuel wrote:
> Hi,
> 
> This is a release of the -16.ucode firmware for Intel Wireless devices
> driven by iwlmvm.
> 
> This firmware is supported by kernel 4.3 and newer.
> Please pull.

pulled, thanks dude.

cheers, --kyle

> 
> Thanks!
> 
> The following changes since commit 1406ec112423c8f70d503d3cd44c6f8e147f7ac3:
> 
>   linux-firmware: Update firmware patch for Intel Bluetooth 7265 (C0/D0)
> (2015-11-11 16:18:35 -0800)
> 
> are available in the git repository at:
> 
>  
> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git
> tags/iwlwifi-fw-2015-11-18
> 
> for you to fetch changes up to 7514f28c7621398a187e98b9439fba8f9fa5dca0:
> 
>   iwlwifi: add new -16 firmware for iwlmvm devices (2015-11-18 09:51:46
> +0200)
> 
> ----------------------------------------------------------------
> deliver -16.ucode
> 
> ----------------------------------------------------------------
> Emmanuel Grumbach (1):
>       iwlwifi: add new -16 firmware for iwlmvm devices
> 
>  WHENCE                 |  15 +++++++++++++++
>  iwlwifi-3160-16.ucode  | Bin 0 -> 918212 bytes
>  iwlwifi-7260-16.ucode  | Bin 0 -> 1049284 bytes
>  iwlwifi-7265-16.ucode  | Bin 0 -> 1180356 bytes
>  iwlwifi-7265D-16.ucode | Bin 0 -> 1384500 bytes
>  iwlwifi-8000C-16.ucode | Bin 0 -> 2351636 bytes
>  6 files changed, 15 insertions(+)
>  create mode 100644 iwlwifi-3160-16.ucode
>  create mode 100644 iwlwifi-7260-16.ucode
>  create mode 100644 iwlwifi-7265-16.ucode
>  create mode 100644 iwlwifi-7265D-16.ucode
>  create mode 100644 iwlwifi-8000C-16.ucode
> 
> diff --git a/WHENCE b/WHENCE
> index cbe528e..e06b53b 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -833,6 +833,9 @@ Version: 25.17.12.0
>  File: iwlwifi-7260-13.ucode
>  Version: 25.30.13.0
>  
> +File: iwlwifi-7260-16.ucode
> +Version 16.242414.0
> +
>  File: iwlwifi-3160-7.ucode
>  Version: 22.1.7.0
>  
> @@ -851,6 +854,9 @@ Version: 25.17.12.0
>  File: iwlwifi-3160-13.ucode
>  Version: 25.30.13.0
>  
> +File: iwlwifi-3160-16.ucode
> +Version 16.242414.0
> +
>  File: iwlwifi-7265-8.ucode
>  Version: 22.24.8.0
>  
> @@ -866,6 +872,9 @@ Version: 25.17.12.0
>  File: iwlwifi-7265-13.ucode
>  Version: 25.30.13.0
>  
> +File: iwlwifi-7265-16.ucode
> +Version 16.242414.0
> +
>  File: iwlwifi-7265D-10.ucode
>  Version: 23.15.10.0
>  
> @@ -875,9 +884,15 @@ Version: 25.17.12.0
>  File: iwlwifi-7265D-13.ucode
>  Version: 25.30.13.0
>  
> +File: iwlwifi-7265D-16.ucode
> +Version 16.242414.0
> +
>  File: iwlwifi-8000C-13.ucode
>  Version: 25.30.13.0
>  
> +File: iwlwifi-8000C-16.ucode
> +Version 16.242414.0
> +
>  Licence: Redistributable. See LICENCE.iwlwifi_firmware for details
>  
>  Also available from
> http://wireless.kernel.org/en/users/Drivers/iwlwifi#Firmware
> diff --git a/iwlwifi-3160-16.ucode b/iwlwifi-3160-16.ucode
> new file mode 100644
> index 0000000..f6a02b6
> Binary files /dev/null and b/iwlwifi-3160-16.ucode differ
> diff --git a/iwlwifi-7260-16.ucode b/iwlwifi-7260-16.ucode
> new file mode 100644
> index 0000000..1f954da
> Binary files /dev/null and b/iwlwifi-7260-16.ucode differ
> diff --git a/iwlwifi-7265-16.ucode b/iwlwifi-7265-16.ucode
> new file mode 100644
> index 0000000..37060e6
> Binary files /dev/null and b/iwlwifi-7265-16.ucode differ
> diff --git a/iwlwifi-7265D-16.ucode b/iwlwifi-7265D-16.ucode
> new file mode 100644
> index 0000000..b8efb69
> Binary files /dev/null and b/iwlwifi-7265D-16.ucode differ
> diff --git a/iwlwifi-8000C-16.ucode b/iwlwifi-8000C-16.ucode
> new file mode 100644
> index 0000000..0a43568
> Binary files /dev/null and b/iwlwifi-8000C-16.ucode differ
> 
> 
