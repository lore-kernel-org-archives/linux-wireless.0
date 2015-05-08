Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:58661 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbbEHRzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 13:55:43 -0400
Message-ID: <554CF89D.403@broadcom.com> (sfid-20150508_195547_450498_6642FD7D)
Date: Fri, 8 May 2015 19:55:41 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kyle McMartin <kyle@infradead.org>
CC: <linux-firmware@kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] brcm: add firmware for BCM4324(1) B5 chipset
References: <1429518626-15321-1-git-send-email-arend@broadcom.com> <1429518626-15321-5-git-send-email-arend@broadcom.com> <20150508170142.GJ27807@merlin.infradead.org>
In-Reply-To: <20150508170142.GJ27807@merlin.infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/15 19:01, Kyle McMartin wrote:
> On Mon, Apr 20, 2015 at 10:30:26AM +0200, Arend van Spriel wrote:
>> This patch provides firmware for the B5 version of the BCM4324(1)
>> device. This device can be found in Lenovo Thinkpad Tablets.
>>
>> Reviewed-by: Pieter-Paul Giesberts<pieterpg@broadcom.com>
>> Reviewed-by: Hante Meuleman<meuleman@broadcom.com>
>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>> ---
>>   brcm/brcmfmac43241b5-sdio.bin | Bin 0 ->  408682 bytes
>>   1 file changed, 0 insertions(+), 0 deletions(-)
>>   create mode 100644 brcm/brcmfmac43241b5-sdio.bin
>>
>
> Please make sure to add files to WHENCE when you submit new firmwares.
> I've added this one myself.

Ah. Sorry. It is on my checklist for firmware submissions, but it 
slipped this time.

Regards,
Arend

> regards, --Kyle

