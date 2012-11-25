Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2193 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab2KYMZn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 07:25:43 -0500
Message-ID: <50B20E3B.9040806@broadcom.com> (sfid-20121125_132545_872996_7ECA254E)
Date: Sun, 25 Nov 2012 13:25:31 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Rafal Milecki" <zajec5@gmail.com>,
	"Hauke Mehrtens" <hauke@hauke-m.de>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: mipsel: compile warning in drivers/bcma/driver_pci_host.c
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I got the following warning compiling with gcc 4.7.2 for MIPS (based on
bcm47xx_defconfig).

*mipsel*:
  CC      drivers/bcma/driver_pci_host.o
drivers/bcma/driver_pci_host.c: In function 'bcma_core_pci_fixup_addresses':
drivers/bcma/driver_pci_host.c:555:23: error: ignoring return value of
'pci_assign_resource', declared with attribute warn_unused_result
[-Werror=unused-result]

Gr. AvS

