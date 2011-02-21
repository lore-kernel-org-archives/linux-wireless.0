Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54238 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab1BUUwh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 15:52:37 -0500
Received: by qwd7 with SMTP id 7so2343755qwd.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Feb 2011 12:52:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298318710-23775-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1298318710-23775-1-git-send-email-wey-yi.w.guy@intel.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 21 Feb 2011 21:29:30 +0100
Message-ID: <AANLkTikFAzdV=A0uEo+5D4ixwgNz0XA3ogA00Wm=r-8t@mail.gmail.com>
Subject: Re: [ipw3945-devel] [PATCH wireless-2.6] iwlagn: Support new 5000 microcode.
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, stable@kernel.org,
	linux-wireless@vger.kernel.org,
	"Fry, Donald H" <donald.h.fry@intel.com>,
	ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 21, 2011 at 9:05 PM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> From: Fry, Donald H <donald.h.fry@intel.com>
>
> New iwlwifi-5000 microcode requires driver support for API version 5.
>
> Signed-off-by: Don Fry <donald.h.fry@intel.com>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> CC: stable@kernel.org
> ---
> these patches are also available from wireless-2.6 branch on
>  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
>
>  drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
> index 79ab0a6..537fb8c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-5000.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
> @@ -51,7 +51,7 @@
>  #include "iwl-agn-debugfs.h"
>
>  /* Highest firmware API version supported */
> -#define IWL5000_UCODE_API_MAX 2
> +#define IWL5000_UCODE_API_MAX 5

Where are versions 3 and 4?

>  #define IWL5150_UCODE_API_MAX 2
>
>  /* Lowest firmware API version supported */
> --
> 1.7.0.4
>
>
> ------------------------------------------------------------------------------
> Free Software Download:
> Index, Search & Analyze Logs and other IT data in Real-Time with Splunk
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
