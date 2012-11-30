Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54931 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758564Ab2K3PB1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 10:01:27 -0500
Message-ID: <50B8CA3B.4070802@hauke-m.de> (sfid-20121130_160131_143122_2073E8B9)
Date: Fri, 30 Nov 2012 16:01:15 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Rafal Milecki <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mipsel: compile warning in drivers/bcma/driver_pci_host.c
References: <50B20E3B.9040806@broadcom.com>
In-Reply-To: <50B20E3B.9040806@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/25/2012 01:25 PM, Arend van Spriel wrote:
> I got the following warning compiling with gcc 4.7.2 for MIPS (based on
> bcm47xx_defconfig).
> 
> *mipsel*:
>   CC      drivers/bcma/driver_pci_host.o
> drivers/bcma/driver_pci_host.c: In function 'bcma_core_pci_fixup_addresses':
> drivers/bcma/driver_pci_host.c:555:23: error: ignoring return value of
> 'pci_assign_resource', declared with attribute warn_unused_result
> [-Werror=unused-result]
> 
> Gr. AvS
> 
Hi Arend,

Thanks for the info, this patch should fix this issue:
http://www.spinics.net/lists/linux-wireless/msg99670.html

Hauke
