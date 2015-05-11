Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51155 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbbEKNsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 09:48:47 -0400
Date: Mon, 11 May 2015 09:48:45 -0400
From: Kyle McMartin <kyle@infradead.org>
To: "Machani, Yaniv" <yanivma@ti.com>
Cc: "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: wl18xx : firmware pull request [V2] (updated WHENCE)
Message-ID: <20150511134844.GN27807@merlin.infradead.org> (sfid-20150511_154930_990330_2BCCBF3C)
References: <AE1C82FB3D0EC64DB1F752C81CBD1101265F6B46@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AE1C82FB3D0EC64DB1F752C81CBD1101265F6B46@DFRE01.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 10, 2015 at 05:46:38AM +0000, Machani, Yaniv wrote:
> - Firmware file was updated (8.9.0.0.39), includes bug fixes and improvements.
> - Configuration binary removed, it is no longer fits all releases.
>   Moreover it should be configured per HW platform.
>   More information can found in here :
>   http://processors.wiki.ti.com/index.php/Open_Source_Wireless_Connectivity_wlconf
> 

I assume this is an embedded part, and not something for general use?
In general, we'd like linux-firmware to be decoupled from kernel
upgrades, so that distributions can upgrade them asynchronously, and
removing wlconf.bin could break existing users.

>   git@git.ti.com:wilink8-wlan/linux-firmware.git for-upstream
> 

FWIW, you need to specify the public git:// url here instead of SSH.

> for you to fetch changes up to dbe3f134bb69b62edd29be89452d016def8f6d7f
> Yaniv Machani (1):
>       wl18xx: update firmware file, remove conf file
> 

Pulled.

>  WHENCE                          |    4 +---
>  ti-connectivity/wl18xx-conf.bin |  Bin 1221 -> 0 bytes
>  ti-connectivity/wl18xx-fw-4.bin |  Bin 681704 -> 724716 bytes
>  3 files changed, 1 insertions(+), 3 deletions(-)
>  delete mode 100644 ti-connectivity/wl18xx-conf.bin
> 

regards, Kyle
