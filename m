Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1397 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488Ab0KST1b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 14:27:31 -0500
From: "Brett Rudley" <brudley@broadcom.com>
To: "Mike Rapoport" <mike.rapoport@gmail.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>
cc: "Henry Ptasinski" <henryp@broadcom.com>,
	"Dowan Kim" <dowan@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 19 Nov 2010 11:27:22 -0800
Subject: RE: [PATCH 0/4] staging: brcm80211: misc cleanups
Message-ID: <7A94256FD72B884D9E7C55586C3CBCEE138429379A@SJEXCHCCR01.corp.ad.broadcom.com>
References: <cover.1289734125.git.mike.rapoport@gmail.com>
In-Reply-To: <cover.1289734125.git.mike.rapoport@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


There was a little confusion within our fullmac team but they say these are OK.

Thanks greg for asking.

Signed-off-by: Brett Rudley<brudley@broadcom.com>


> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Mike Rapoport
> Sent: Sunday, November 14, 2010 3:36 AM
> To: Greg Kroah-Hartman
> Cc: Brett Rudley; Henry Ptasinski; Dowan Kim; linux-
> wireless@vger.kernel.org; Mike Rapoport
> Subject: [PATCH 0/4] staging: brcm80211: misc cleanups
> 
> These patches remove some unused declarations in include/linux_osl.h
> and unused bindings to SDIO controller devices in brcmfmac driver
> 
> Mike Rapoport (4):
>   staging: brcm80211: remove unused osl_pkt{get,free}_static
>   staging: brcm80211: brcmfmac: remove PCI SDIO controller binding
>   staging: brcm80211: brcmfmac: remove PXA SDIO controller binding
>   staging: brcm80211: brcmfmac: cleanup bcmsdh_(un)register
> 
>  drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |  259 +--------------
> ------
>  drivers/staging/brcm80211/include/linux_osl.h     |    3 -
>  2 files changed, 1 insertions(+), 261 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


