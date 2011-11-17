Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab1KQWeZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 17:34:25 -0500
Subject: Re: [PATCH 0/3] linux-firmware: new firmware for brcmfmac and
 nvram removal
From: Johannes Berg <johannes@sipsolutions.net>
To: Franky Lin <frankyl@broadcom.com>
Cc: dwmw2@infradead.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <1321569101-19568-1-git-send-email-frankyl@broadcom.com> (sfid-20111117_233154_459786_40512EB4)
References: <1321569101-19568-1-git-send-email-frankyl@broadcom.com>
	 (sfid-20111117_233154_459786_40512EB4)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 23:34:22 +0100
Message-ID: <1321569262.3997.54.camel@jlt3.sipsolutions.net> (sfid-20111117_233428_662677_374FDE78)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-11-17 at 14:31 -0800, Franky Lin wrote:
> This patch series adds new firmware for bcm4329 and bcm4330 and removes
> the nvram file from the repository as it is not useful for Linux users
> and only used for internal development.
> 
> Franky Lin (3):
>   linux-firmware: add new bcm4329 firmware for brcmfmac
>   linux-firmware: add bcm4330 firmware for brcmfmac
>   linux-firmware: remove nvram file for bcm4329 development board
> 
>  brcm/bcm4329-fullmac-4.txt |   94 --------------------------------------------
>  brcm/brcmfmac4329.bin      |  Bin 0 -> 253748 bytes
>  brcm/brcmfmac4330.bin      |  Bin 0 -> 222126 bytes

Don't you need to update WHENCE for new files?

johannes

