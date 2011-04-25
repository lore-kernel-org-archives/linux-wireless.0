Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:52603 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503Ab1DYXmi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 19:42:38 -0400
Date: Mon, 25 Apr 2011 16:40:54 -0700
From: Greg KH <greg@kroah.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org, hharte@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/7] staging: brcm80211: remove si sb utils dependency
 from brcmfmac
Message-ID: <20110425234054.GA15575@kroah.com> (sfid-20110426_014241_777887_7A5DEE44)
References: <1303771513-18851-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303771513-18851-1-git-send-email-frankyl@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 25, 2011 at 03:45:06PM -0700, Franky Lin wrote:
> This patch series is intend to remove si and sb utility from broadcom fullmac driver.
> 
> Franky Lin (7):
>   staging: brcm80211: Add bcmchip.h
>   staging: brcm80211: Add dhdsdio_chip_attach in dhd_sdio.c
>   staging: brcm80211: Remove siutils dependency of
>     dhdsdio_download_state
>   staging: brcm80211: Move sdiod strength init to dhd_sdio.c
>   staging: brcm80211: Add dhdsdio_chip_detach in dhd_sdio.c
>   staging: brcm80211: Remove siutils dependence from dhd_sdio.c
>   staging: brcm80211: Remove si sb utils from brcmfmac

The first 2 applied, the rest did not :(
