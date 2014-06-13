Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35626 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaFMQAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 12:00:11 -0400
Date: Fri, 13 Jun 2014 11:46:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jahnavi Meher <jahnavi.meher@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/5] Fixes, changes for 40MHz and adding support for 5GHz
 and bgscan.
Message-ID: <20140613154618.GA8392@tuxdriver.com> (sfid-20140613_180026_316033_2694E2E5)
References: <1402670579-8818-1-git-send-email-jahnavi.meher@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1402670579-8818-1-git-send-email-jahnavi.meher@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Your subject lines should be prefixed with the driver (or subcomponent) name...

rsi: fixes and clean up of code
rsi: change the logic for dequeuing packets in hal.
rsi: adding support for 5GHz.
rsi: adding support for host based bgscan
rsi: changes for 40MHz

On Fri, Jun 13, 2014 at 08:12:59PM +0530, Jahnavi Meher wrote:
> This series of patches contains some fixes, adds support for
> 5GHz and bgscan and contains changes required for 40MHz. Also
> the logic related to dequeuing of packets from hal has been
> changed.
> 
> Jahnavi Meher (5):
>   Fixes and clean up of code
>   Change the logic for dequeuing packets in hal.
>   Adding support for 5GHz.
>   Adding support for host based bgscan
>   Changes for 40MHz
> 
>  drivers/net/wireless/rsi/rsi_91x_core.c     |   85 +++++++---
>  drivers/net/wireless/rsi/rsi_91x_debugfs.c  |   10 +-
>  drivers/net/wireless/rsi/rsi_91x_mac80211.c |  143 ++++++++++++++---
>  drivers/net/wireless/rsi/rsi_91x_mgmt.c     |  237 +++++++++++++++++++--------
>  drivers/net/wireless/rsi/rsi_91x_pkt.c      |   17 ++
>  drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |    8 +-
>  drivers/net/wireless/rsi/rsi_main.h         |   12 ++
>  drivers/net/wireless/rsi/rsi_mgmt.h         |   25 +++-
>  drivers/net/wireless/rsi/rsi_sdio.h         |    8 +-
>  9 files changed, 416 insertions(+), 129 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
