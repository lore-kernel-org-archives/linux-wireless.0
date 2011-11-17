Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1568 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab1KQWks (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 17:40:48 -0500
Message-ID: <4EC58D60.5020808@broadcom.com> (sfid-20111117_234052_672689_C06E5072)
Date: Thu, 17 Nov 2011 14:40:32 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"dwmw2@infradead.org" <dwmw2@infradead.org>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH 0/3] linux-firmware: new firmware for brcmfmac and
 nvram removal
References: <1321569101-19568-1-git-send-email-frankyl@broadcom.com> (
 sfid-20111117_233154_459786_40512EB4)
 <1321569262.3997.54.camel@jlt3.sipsolutions.net>
In-Reply-To: <1321569262.3997.54.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/17/2011 02:34 PM, Johannes Berg wrote:
> On Thu, 2011-11-17 at 14:31 -0800, Franky Lin wrote:
>> This patch series adds new firmware for bcm4329 and bcm4330 and removes
>> the nvram file from the repository as it is not useful for Linux users
>> and only used for internal development.
>>
>> Franky Lin (3):
>>    linux-firmware: add new bcm4329 firmware for brcmfmac
>>    linux-firmware: add bcm4330 firmware for brcmfmac
>>    linux-firmware: remove nvram file for bcm4329 development board
>>
>>   brcm/bcm4329-fullmac-4.txt |   94 --------------------------------------------
>>   brcm/brcmfmac4329.bin      |  Bin 0 ->  253748 bytes
>>   brcm/brcmfmac4330.bin      |  Bin 0 ->  222126 bytes
>
> Don't you need to update WHENCE for new files?
>

Opps, I missed that. Thanks Johannes.

David, could you please drop this train? I will send a V2 with WHENCE 
updated correspondingly.

Thanks,
Franky


