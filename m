Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2801 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab2LCUmh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 15:42:37 -0500
Message-ID: <50BD0EB2.7050701@broadcom.com> (sfid-20121203_214240_725148_6328BFD4)
Date: Mon, 3 Dec 2012 21:42:26 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "Rafal Milecki" <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mipsel: compile warning in drivers/bcma/driver_pci_host.c
References: <50B20E3B.9040806@broadcom.com>
 <50B8CA3B.4070802@hauke-m.de>
In-Reply-To: <50B8CA3B.4070802@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/30/2012 04:01 PM, Hauke Mehrtens wrote:
> On 11/25/2012 01:25 PM, Arend van Spriel wrote:
>> I got the following warning compiling with gcc 4.7.2 for MIPS (based on
>> bcm47xx_defconfig).
>>
>> *mipsel*:
>>   CC      drivers/bcma/driver_pci_host.o
>> drivers/bcma/driver_pci_host.c: In function 'bcma_core_pci_fixup_addresses':
>> drivers/bcma/driver_pci_host.c:555:23: error: ignoring return value of
>> 'pci_assign_resource', declared with attribute warn_unused_result
>> [-Werror=unused-result]
>>
>> Gr. AvS
>>
> Hi Arend,
> 
> Thanks for the info, this patch should fix this issue:
> http://www.spinics.net/lists/linux-wireless/msg99670.html
> 
> Hauke
> 

Yes,

I already saw that patch flying by.

Gr. AvS

