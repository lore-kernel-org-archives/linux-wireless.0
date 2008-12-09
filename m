Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:39927 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbYLITu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 14:50:59 -0500
Subject: Re: [PATCH 1/4] iwlwifi: change email contact information
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>
In-Reply-To: <1228850941-16677-2-git-send-email-reinette.chatre@intel.com>
References: <> <1228850941-16677-1-git-send-email-reinette.chatre@intel.com>
	 <1228850941-16677-2-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 20:50:51 +0100
Message-Id: <1228852251.19553.125.camel@violet.holtmann.net> (sfid-20081209_205103_242641_1B6987A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Reinette,

> This patch replaces personal emails with hopefully
> always valid Intel Linux Wireless, which will be routed
> to a current maintainer
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-3945-commands.h  |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-3945-core.h      |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-3945-debug.h     |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-3945-hw.h        |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-3945-io.h        |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-3945-led.c       |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-3945-led.h       |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-3945-rs.c        |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-3945-rs.h        |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-3945.c           |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-3945.h           |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-4965-hw.h        |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-4965.c           |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-5000-hw.h        |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-agn-rs.h         |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-agn.c            |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-calib.c          |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-calib.h          |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-commands.h       |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-core.c           |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-core.h           |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-csr.h            |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-debug.h          |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-debugfs.c        |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-dev.h            |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-eeprom.c         |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-eeprom.h         |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-fh.h             |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-hcmd.c           |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-helpers.h        |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-io.h             |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-led.c            |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-led.h            |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-power.c          |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-power.h          |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-prph.h           |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-rfkill.c         |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-rfkill.h         |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-rx.c             |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-scan.c           |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-spectrum.c       |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-spectrum.h       |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-sta.c            |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-sta.h            |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-tx.c             |    2 +-
>  drivers/net/wireless/iwlwifi/iwl3945-base.c       |    2 +-
>  48 files changed, 48 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
> index daf99ea..c6f4eb5 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
> @@ -25,7 +25,7 @@
>   * in the file called LICENSE.GPL.
>   *
>   * Contact Information:
> - * James P. Ketrenos <ipw2100-admin@linux.intel.com>
> + *  Intel Linux Wireless <ilw@linux.intel.com>
>   * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497

just double checking that "ilw" is intentional. It is kinda weird since
we prefix our driver with "iwl". It might be a little bit confusing.

Also the MODULE_AUTHOR tag should contain the maintainer information. At
least that is what the current consensus is. I know that the word author
is kinda misleading here.

Regards

Marcel


