Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39685 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbbBFJPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 04:15:07 -0500
Date: Fri, 6 Feb 2015 04:15:06 -0500
From: Kyle McMartin <kyle@infradead.org>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhao, Yingying" <yingying.zhao@intel.com>
Subject: Re: pull request: new firmware for Intel wireless Intel 3160 / 7260
 / 7265 / 7265D devices
Message-ID: <20150206091506.GE30928@merlin.infradead.org> (sfid-20150206_101513_842041_40A9298B)
References: <1422999252.29907.18.camel@egrumbacBox>
 <1422999568.29907.24.camel@egrumbacBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422999568.29907.24.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 03, 2015 at 09:39:28PM +0000, Grumbach, Emmanuel wrote:
> Hi,
> 
> This is a pull request for new firmwares for the Intel wireless devices
> mentioned in the subject.
> 
> I replace -10.ucode with new ones (that includes bug fixes).
> I add the brand new -12.ucode.
> 
> Please pull.
> 
> The following changes since commit
> 38e5405c96d10bb42b629b45210c46166461fc21:
> 

oh, heh, only 1 commit, not 3. ;-)

applied, thanks Emmanuel.

regards, Kyle

>   cxgb4: Update firmware to revision 1.12.25.0 (2014-12-01 15:48:02
> -0500)
> 
> are available in the git repository at:
> 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git
> master
> 
> for you to fetch changes up to da4e58d47557776c5721bafb3f2b6c4a1a4ff0f3:
> 
>   iwlwifi: add new -12 firmware for 3160 / 7260 / 7265 / 7265D
> (2015-02-03 23:14:51 +0200)
> 
> ----------------------------------------------------------------
> Emmanuel Grumbach (3):
>       iwlwifi: update -10.ucode for 3160 / 7260 / 7265 / 7265D
>       iwlwifi: update -10.ucode for 3160 / 7260 / 7265 / 7265D
>       iwlwifi: add new -12 firmware for 3160 / 7260 / 7265 / 7265D
> 
>  WHENCE                 |  20 ++++++++++++++++----
>  iwlwifi-3160-10.ucode  | Bin 610168 -> 610064 bytes
>  iwlwifi-3160-12.ucode  | Bin 0 -> 683996 bytes
>  iwlwifi-7260-10.ucode  | Bin 672480 -> 672372 bytes
>  iwlwifi-7260-12.ucode  | Bin 0 -> 782300 bytes
>  iwlwifi-7265-10.ucode  | Bin 736968 -> 736864 bytes
>  iwlwifi-7265-12.ucode  | Bin 0 -> 880604 bytes
>  iwlwifi-7265D-10.ucode | Bin 740636 -> 740456 bytes
>  iwlwifi-7265D-12.ucode | Bin 0 -> 1002800 bytes
>  9 files changed, 16 insertions(+), 4 deletions(-)
>  create mode 100644 iwlwifi-3160-12.ucode
>  create mode 100644 iwlwifi-7260-12.ucode
>  create mode 100644 iwlwifi-7265-12.ucode
>  create mode 100644 iwlwifi-7265D-12.ucode
> 
> diff --git a/WHENCE b/WHENCE
> index 44c41c7..1917288 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -816,7 +816,10 @@ File: iwlwifi-7260-9.ucode
>  Version: 25.228.9.0
>  
>  File: iwlwifi-7260-10.ucode
> -Version: 23.10.10.0
> +Version: 23.12.10.0
> +
> +File: iwlwifi-7260-12.ucode
> +Version: 25.15.12.0
>  
>  File: iwlwifi-3160-7.ucode
>  Version: 22.1.7.0
> @@ -828,7 +831,10 @@ File: iwlwifi-3160-9.ucode
>  Version: 25.228.9.0
>  
>  File: iwlwifi-3160-10.ucode
> -Version: 23.10.10.0
> +Version: 23.12.10.0
> +
> +File: iwlwifi-3160-12.ucode
> +Version: 25.15.12.0
>  
>  File: iwlwifi-7265-8.ucode
>  Version: 22.24.8.0
> @@ -837,10 +843,16 @@ File: iwlwifi-7265-9.ucode
>  Version: 25.228.9.0
>  
>  File: iwlwifi-7265-10.ucode
> -Version: 23.10.10.0
> +Version: 23.12.10.0
> +
> +File: iwlwifi-7265-12.ucode
> +Version: 25.15.12.0
>  
>  File: iwlwifi-7265D-10.ucode
> -Version: 23.10.10.0
> +Version: 23.12.10.0
> +
> +File: iwlwifi-7265D-12.ucode
> +Version: 25.15.12.0
>  
>  Licence: Redistributable. See LICENCE.iwlwifi_firmware for details
>  
> diff --git a/iwlwifi-3160-10.ucode b/iwlwifi-3160-10.ucode
> index 8cec7bf..5f4173c 100644
> Binary files a/iwlwifi-3160-10.ucode and b/iwlwifi-3160-10.ucode differ
> diff --git a/iwlwifi-3160-12.ucode b/iwlwifi-3160-12.ucode
> new file mode 100644
> index 0000000..45bce48
> Binary files /dev/null and b/iwlwifi-3160-12.ucode differ
> diff --git a/iwlwifi-7260-10.ucode b/iwlwifi-7260-10.ucode
> index 9e5b930..dca79e2 100644
> Binary files a/iwlwifi-7260-10.ucode and b/iwlwifi-7260-10.ucode differ
> diff --git a/iwlwifi-7260-12.ucode b/iwlwifi-7260-12.ucode
> new file mode 100644
> index 0000000..7ec91f0
> Binary files /dev/null and b/iwlwifi-7260-12.ucode differ
> diff --git a/iwlwifi-7265-10.ucode b/iwlwifi-7265-10.ucode
> index 488ddd0..0571fcf 100644
> Binary files a/iwlwifi-7265-10.ucode and b/iwlwifi-7265-10.ucode differ
> diff --git a/iwlwifi-7265-12.ucode b/iwlwifi-7265-12.ucode
> new file mode 100644
> index 0000000..84ae2ce
> Binary files /dev/null and b/iwlwifi-7265-12.ucode differ
> diff --git a/iwlwifi-7265D-10.ucode b/iwlwifi-7265D-10.ucode
> index 01194db..d9b9aaf 100644
> Binary files a/iwlwifi-7265D-10.ucode and b/iwlwifi-7265D-10.ucode
> differ
> diff --git a/iwlwifi-7265D-12.ucode b/iwlwifi-7265D-12.ucode
> new file mode 100644
> index 0000000..3f36b55
> Binary files /dev/null and b/iwlwifi-7265D-12.ucode differ
> 


