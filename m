Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f183.google.com ([209.85.211.183]:37622 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbZHFE1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 00:27:14 -0400
MIME-Version: 1.0
In-Reply-To: <1249532170.21101.3.camel@localhost.localdomain>
References: <1249523981-26601-1-git-send-email-lrodriguez@atheros.com>
	<1249532170.21101.3.camel@localhost.localdomain>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 5 Aug 2009 21:26:54 -0700
Message-ID: <43e72e890908052126v53aa1b4sb7a48e19f98fdfa6@mail.gmail.com>
Subject: Re: [PATCH] pci_ids.h: add new Atheros USB vendor ID
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, zhifeng.cai@atheros.com,
	stephen.chen@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 5, 2009 at 9:16 PM, Marcel Holtmann<marcel@holtmann.org> wrote:
> Hi Luiz,
>
>> New Atheros USB devices will use 0x0cf3. The first device
>> will be ar9271, for which we are adding support for.
>>
>> Cc: zhifeng.cai@atheros.com
>> Cc: stephen.chen@atheros.com
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>
>> John, sending this through you as this is only
>> specific to wireless, at least at the moment.
>>
>>  include/linux/pci_ids.h |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
>> index 73b46b6..27f4e6b 100644
>> --- a/include/linux/pci_ids.h
>> +++ b/include/linux/pci_ids.h
>> @@ -2170,6 +2170,7 @@
>>  #define PCI_DEVICE_ID_BCM1250_HT     0x0002
>>
>>  #define PCI_VENDOR_ID_ATHEROS                0x168c
>> +#define PCI_VENDOR_ID_ATHEROS_USB    0x0cf3
>
> this is confusing the hell out of me. What are you adding here.

No you're right, my fault.

> A USB
> vendor id or a PCI one. Is the ar9271 a PCI device or a USB device?

Its only USB.

Thanks... hm I see no USB vendor id headers. Guess we won't need to add this.

  Luis
