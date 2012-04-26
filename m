Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4646 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab2DZI4s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 04:56:48 -0400
Message-ID: <4F990DC1.4070305@broadcom.com> (sfid-20120426_105834_140333_71CDEE8F)
Date: Thu, 26 Apr 2012 10:56:33 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Nathan Hintz" <nlhintz@hotmail.com>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	hauke@hauke-m.de
Subject: Re: [PATCH v2 0/6] BCMA Cumulative patches from OpenWRT
References: <BLU0-SMTP45859B1CA3415BE44C9024CAC240@phx.gbl>
In-Reply-To: <BLU0-SMTP45859B1CA3415BE44C9024CAC240@phx.gbl>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/2012 06:23 AM, Nathan Hintz wrote:
> Nathan Hintz (6):
>    bcma: Find names of non BCM cores
>    bcma: Move initialization of SPROM to prevent overwrite
>    bcma: Account for variable PCI memory base/size
>    bcma: reads/writes are always 4 bytes, so always map 4 bytes
>    bcma: Add __devexit to bcma_host_pci_remove
>    bcma: Add flush for BCMA_RESET_CTL write
>
>   arch/mips/bcm47xx/setup.c      |    4 +++
>   arch/mips/bcm47xx/sprom.c      |    2 -
>   drivers/bcma/core.c            |    1 +
>   drivers/bcma/driver_pci_host.c |   10 +++---
>   drivers/bcma/host_pci.c        |    4 +-
>   drivers/bcma/scan.c            |   54 +++++++++++++++++++++++++++++----------
>   6 files changed, 52 insertions(+), 23 deletions(-)
>

None of these patches have any description. Some motivation for the 
changes would be appreciated like 'reported problem', 'new target 
support', etc.

Gr. AvS

