Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:37290 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaCRLta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 07:49:30 -0400
Message-ID: <532832C1.2050901@broadcom.com> (sfid-20140318_124933_826269_3CDDD1F8)
Date: Tue, 18 Mar 2014 12:49:21 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] brcm: add firmware for the BCM43362 WLAN device
References: <1393014109-4712-1-git-send-email-arend@broadcom.com> <1394993460.15764.89.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1394993460.15764.89.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16/03/14 19:11, Ben Hutchings wrote:
> On Fri, 2014-02-21 at 21:21 +0100, Arend van Spriel wrote:
>> This patch adds firmware for the BCM43362 for which recently
>> support has been added to the brcmfmac driver.
>>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>>   WHENCE                      |    1 +
>>   brcm/brcmfmac43362-sdio.bin |  Bin 0 -> 219557 bytes
>>   2 files changed, 1 insertion(+)
>>   create mode 100644 brcm/brcmfmac43362-sdio.bin
> [...]
>
> Applied, thanks.  Sorry for the delay.

No problem. Support is added in 3.14 so still ahead of the release.

Thanks,
Arend
