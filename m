Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4773 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab2FGUFp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 16:05:45 -0400
Message-ID: <4FD10989.6040701@broadcom.com> (sfid-20120607_220549_554877_21DADCDF)
Date: Thu, 7 Jun 2012 22:05:29 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/18] brcmsmac: remove PCIE() makro
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338937641-8519-2-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
> Instead of checking if there is a PCIe core on the bus, better check if
> hosttype is PCIe.

I was under the impression that the macro was used for code needed when
the chip has a PCIe core instead of a PCI core. Maybe BCMA only supports
chips with PCIe core and in the respect checking the hosttype is
essentially the same, but I would not necessarily call it better.

> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 

Gr. AvS

