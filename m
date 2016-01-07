Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46917 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbcAGN7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 08:59:20 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Rodrigo Freire <rfreire@redhat.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
CC: linuxwifi <linuxwifi@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: Document missing module options
Date: Thu, 7 Jan 2016 13:59:16 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E983FBD@hasmsx107.ger.corp.intel.com> (sfid-20160107_145937_103821_3C3C19C1)
References: <91cd61cc8ed52fab61dcf19531d821dda75db267.1452118569.git.rfreire@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


On 01/07/2016 12:24 AM, Rodrigo Freire wrote:
> This patch documents two missing module options in the internal
> code comment block.
>
> Signed-off-by: Rodrigo Freire <rfreire@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-modparams.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
> index ac2b90d..1477277 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
> @@ -102,6 +102,8 @@ enum iwl_disable_11n {
>   * @power_level: power level, default = 1
>   * @debug_level: levels are IWL_DL_*
>   * @ant_coupling: antenna coupling in dB, default = 0
> + * @nvm_file: specifies a external NVM file
> + * @uapsd_disable: disable U-APSD, default = 1
>   * @d0i3_disable: disable d0i3, default = 1,
>   * @lar_disable: disable LAR (regulatory), default = 0
>   * @fw_monitor: allow to use firmware monitor
Applied in our internal tree. Thanks.
