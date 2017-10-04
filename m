Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:2428 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751135AbdJDQNe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 12:13:34 -0400
Message-ID: <1507133610.908.89.camel@intel.com> (sfid-20171004_181424_945519_EF153568)
Subject: Re: [PATCH 2/3] wireless: iwlwifi: function definition cosmetic fix
From: Luciano Coelho <luciano.coelho@intel.com>
To: Christoph =?ISO-8859-1?Q?B=F6hmwalder?=
        <christoph@boehmwalder.at>, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 04 Oct 2017 19:13:30 +0300
In-Reply-To: <20171004155700.18048-3-christoph@boehmwalder.at>
References: <20171004155700.18048-1-christoph@boehmwalder.at>
         <20171004155700.18048-3-christoph@boehmwalder.at>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-10-04 at 17:56 +0200, Christoph Böhmwalder wrote:
> Separate the function from the previous definition with a newline and
> put the `static` keyword on the same line, as it just looks nicer.
> 
> Signed-off-by: Christoph Böhmwalder <christoph@boehmwalder.at>
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
> index 0eb815ae97e8..249ee1c7b02f 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
> @@ -325,8 +325,8 @@ static u16 channel_id_to_txp(struct iwl_phy_db *phy_db, u16 ch_id)
>  	}
>  	return 0xff;
>  }
> -static
> -int iwl_phy_db_get_section_data(struct iwl_phy_db *phy_db,
> +
> +static int iwl_phy_db_get_section_data(struct iwl_phy_db *phy_db,
>  				u32 type, u8 **data, u16 *size, u16 ch_id)
>  {
>  	struct iwl_phy_db_entry *entry;

Sorry, but this now looks much uglier because the second line is not
even aligned to the parenthesis.

NACK.

--
Luca.
