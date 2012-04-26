Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:47597 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849Ab2DZLu6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 07:50:58 -0400
From: Kalle Valo <kvalo@adurom.com>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "Nathan Hintz" <nlhintz@hotmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, hauke@hauke-m.de
Subject: Re: [PATCH v2 0/6] BCMA Cumulative patches from OpenWRT
References: <BLU0-SMTP45859B1CA3415BE44C9024CAC240@phx.gbl>
	<4F990DC1.4070305@broadcom.com>
Date: Thu, 26 Apr 2012 14:50:54 +0300
In-Reply-To: <4F990DC1.4070305@broadcom.com> (Arend van Spriel's message of
	"Thu, 26 Apr 2012 10:56:33 +0200")
Message-ID: <87r4vaaezl.fsf@purkki.adurom.net> (sfid-20120426_135101_248519_3EF76078)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Arend van Spriel" <arend@broadcom.com> writes:

> On 04/26/2012 06:23 AM, Nathan Hintz wrote:
>> Nathan Hintz (6):
>>    bcma: Find names of non BCM cores
>>    bcma: Move initialization of SPROM to prevent overwrite
>>    bcma: Account for variable PCI memory base/size
>>    bcma: reads/writes are always 4 bytes, so always map 4 bytes
>>    bcma: Add __devexit to bcma_host_pci_remove
>>    bcma: Add flush for BCMA_RESET_CTL write
>>
>>   arch/mips/bcm47xx/setup.c      |    4 +++
>>   arch/mips/bcm47xx/sprom.c      |    2 -
>>   drivers/bcma/core.c            |    1 +
>>   drivers/bcma/driver_pci_host.c |   10 +++---
>>   drivers/bcma/host_pci.c        |    4 +-
>>   drivers/bcma/scan.c            |   54 +++++++++++++++++++++++++++++----------
>>   6 files changed, 52 insertions(+), 23 deletions(-)
>>
>
> None of these patches have any description. Some motivation for the
> changes would be appreciated like 'reported problem', 'new target
> support', etc.

I would say that it's required. Anyone can see the diff and see what was
changed, but nobody will figure out why the change was made unless it's
described in the commit log. So it's important to answer the question
"Why?".

-- 
Kalle Valo
