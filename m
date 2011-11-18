Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21444 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757273Ab1KRPQ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 10:16:57 -0500
Subject: Re: [PATCH 28/77] iwlegacy: rename base 4965 and 3945 file names
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1321604559-10707-28-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
	 <1321604559-10707-28-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 06:21:38 -0800
Message-ID: <1321626098.11647.13.camel@wwguy-huron> (sfid-20111118_161700_821697_76286088)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-18 at 00:21 -0800, Stanislaw Gruszka wrote:
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlegacy/3945-mac.c     | 4007 ++++++++++++++++++++++++++
>  drivers/net/wireless/iwlegacy/3945.c         | 2740 ++++++++++++++++++
>  drivers/net/wireless/iwlegacy/4965-mac.c     | 3245 +++++++++++++++++++++
>  drivers/net/wireless/iwlegacy/4965.c         | 2183 ++++++++++++++
>  drivers/net/wireless/iwlegacy/Makefile       |    4 +-
>  drivers/net/wireless/iwlegacy/iwl-3945.c     | 2740 ------------------
>  drivers/net/wireless/iwlegacy/iwl-4965.c     | 2183 --------------
>  drivers/net/wireless/iwlegacy/iwl3945-base.c | 4007 --------------------------
>  drivers/net/wireless/iwlegacy/iwl4965-base.c | 3245 ---------------------
>  9 files changed, 12177 insertions(+), 12177 deletions(-)
>  create mode 100644 drivers/net/wireless/iwlegacy/3945-mac.c
>  create mode 100644 drivers/net/wireless/iwlegacy/3945.c
>  create mode 100644 drivers/net/wireless/iwlegacy/4965-mac.c
>  create mode 100644 drivers/net/wireless/iwlegacy/4965.c
>  delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945.c
>  delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965.c
>  delete mode 100644 drivers/net/wireless/iwlegacy/iwl3945-base.c
>  delete mode 100644 drivers/net/wireless/iwlegacy/iwl4965-base.c
> 
> 683K patch can be downloaded from:
> http://people.redhat.com/sgruszka/iwlegacy-2011-11-16/0028-iwlegacy-rename-base-4965-and-3945-file-names.patch
> --
myabe also rename other modules which has "iwl" prefix to "il"? such as
iwl-led.c, iwl-eeprom.c, ...

Thanks
Wey

