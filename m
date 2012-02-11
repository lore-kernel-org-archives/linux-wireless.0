Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4412 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab2BKWpZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Feb 2012 17:45:25 -0500
Message-ID: <4F36EF7E.9060703@broadcom.com> (sfid-20120211_234528_933601_4092AFFA)
Date: Sat, 11 Feb 2012 23:45:18 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Ben Hutchings" <ben@decadent.org.uk>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH 0/4] linux-firmware: brcm: new firmware files for
 brcmfmac and cleanup
References: <1328302605-3382-1-git-send-email-arend@broadcom.com>
 <1328988230.325.24.camel@deadeye>
In-Reply-To: <1328988230.325.24.camel@deadeye>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/11/2012 08:23 PM, Ben Hutchings wrote:
> On Fri, 2012-02-03 at 21:56 +0100, Arend van Spriel wrote:
>> This patch series adds new firmware for bcm4329 and bcm4330 SDIO chipsets
>> and removes the nvram file from the repository as it is not useful for Linux
>> users and only used for internal development.
>>
>> Also included is firmware for the bcm43236 USB chipset, which will be
>> supported by the brcmfmac driver.
>>
>> This series applies to kernel/git/firmware/linux-firmware.git tree. These
>> files will be used by brcmfmac as of kernel v3.3.
> 
> Applied, but:
> 
> [...]
>>  create mode 100755 brcm/brcmfmac4329.bin
>>  create mode 100755 brcm/brcmfmac4330.bin
> 
> I had to fix these permissions.  Please take care to fix executable
> permissions when copying files from non-Unix systems.
> 
> Ben.
> 

Ah, yes. I overlooked. Thanks.

Gr. AvS

