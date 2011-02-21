Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30903 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab1BUTYQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 14:24:16 -0500
Subject: Re: [PATCH 0/4] update for 2.6.39
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1298315209-17986-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1298315209-17986-1-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 11:09:35 -0800
Message-ID: <1298315375.5138.3.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Please drop this series of patches, I will resubmit

Thanks

Wey

On Mon, 2011-02-21 at 11:06 -0800, Guy, Wey-Yi W wrote:
> We splite legacy(3945/4965) from iwlwifi into separated directory(iwlegacy)
> We also fix few firmware related problems
> 
> Wey-Yi Guy (3):
>   iwlwifi: Limit number of firmware reload
>   iwlwifi: Loading correct uCode again when fail to load
>   iwlwifi: enable 2-wire bt coex support for non-combo device
> 
> Meenakshi Venkataraman (1):
>   iwlwifi: split the drivers for agn and legacy devices 3945/4965
> 
> these patches are also available from wireless-next-2.6 branch on
>  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
> 
>  drivers/net/wireless/Kconfig                    |    1 +
>  drivers/net/wireless/Makefile                   |    3 +-
>  drivers/net/wireless/iwlwifi/Kconfig            |  124 +-
>  drivers/net/wireless/iwlwifi/Makefile           |   39 +-
>  drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c |  522 ---
>  drivers/net/wireless/iwlwifi/iwl-3945-debugfs.h |   60 -
>  drivers/net/wireless/iwlwifi/iwl-3945-fh.h      |  188 -
>  drivers/net/wireless/iwlwifi/iwl-3945-hw.h      |  294 --
>  drivers/net/wireless/iwlwifi/iwl-3945-led.c     |   64 -
>  drivers/net/wireless/iwlwifi/iwl-3945-led.h     |   32 -
>  drivers/net/wireless/iwlwifi/iwl-3945-rs.c      |  995 ------
>  drivers/net/wireless/iwlwifi/iwl-3945.c         | 2819 ---------------
>  drivers/net/wireless/iwlwifi/iwl-3945.h         |  308 --
>  drivers/net/wireless/iwlwifi/iwl-4965-hw.h      |  792 -----
>  drivers/net/wireless/iwlwifi/iwl-4965.c         | 2666 --------------
>  drivers/net/wireless/iwlwifi/iwl-agn.c          |   35 +-
>  drivers/net/wireless/iwlwifi/iwl-core.c         |   76 +-
>  drivers/net/wireless/iwlwifi/iwl-debugfs.c      |    2 -
>  drivers/net/wireless/iwlwifi/iwl-dev.h          |   13 +-
>  drivers/net/wireless/iwlwifi/iwl-eeprom.c       |    8 -
>  drivers/net/wireless/iwlwifi/iwl-hcmd.c         |    5 -
>  drivers/net/wireless/iwlwifi/iwl-led.c          |    2 -
>  drivers/net/wireless/iwlwifi/iwl-legacy.c       |  657 ----
>  drivers/net/wireless/iwlwifi/iwl-legacy.h       |   79 -
>  drivers/net/wireless/iwlwifi/iwl-power.c        |    3 -
>  drivers/net/wireless/iwlwifi/iwl-rx.c           |    6 -
>  drivers/net/wireless/iwlwifi/iwl-scan.c         |   10 -
>  drivers/net/wireless/iwlwifi/iwl-sta.c          |   11 -
>  drivers/net/wireless/iwlwifi/iwl-tx.c           |    7 -
>  drivers/net/wireless/iwlwifi/iwl3945-base.c     | 4334 -----------------------
>  30 files changed, 106 insertions(+), 14049 deletions(-)
>  delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c
>  delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.h
>  delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-fh.h
>  delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-hw.h
>  delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-led.c
>  delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-led.h
>  delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-rs.c
>  delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945.c
>  delete mode 100644 drivers/net/wireless/iwlwifi/iwl-3945.h
>  delete mode 100644 drivers/net/wireless/iwlwifi/iwl-4965-hw.h
>  delete mode 100644 drivers/net/wireless/iwlwifi/iwl-4965.c
>  delete mode 100644 drivers/net/wireless/iwlwifi/iwl-legacy.c
>  delete mode 100644 drivers/net/wireless/iwlwifi/iwl-legacy.h
>  delete mode 100644 drivers/net/wireless/iwlwifi/iwl3945-base.c
> 


