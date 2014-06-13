Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbaFMPyh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 11:54:37 -0400
Message-ID: <1402674875.11828.1.camel@dcbw.local> (sfid-20140613_175441_089493_A841B2B5)
Subject: Re: [PATCH 0/5] Fixes, changes for 40MHz and adding support for
 5GHz and bgscan.
From: Dan Williams <dcbw@redhat.com>
To: Jahnavi Meher <jahnavi.meher@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 13 Jun 2014 10:54:35 -0500
In-Reply-To: <1402670579-8818-1-git-send-email-jahnavi.meher@gmail.com>
References: <1402670579-8818-1-git-send-email-jahnavi.meher@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-06-13 at 20:12 +0530, Jahnavi Meher wrote:
> This series of patches contains some fixes, adds support for
> 5GHz and bgscan and contains changes required for 40MHz. Also
> the logic related to dequeuing of packets from hal has been
> changed.

No comment yet on the patches themselves, but you probably want to
prefix the mails (and git commits) with "rsi: <rest of message>".
Probably just forgot this time since the last version of this patchset
had the right prefix :)

dan

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


