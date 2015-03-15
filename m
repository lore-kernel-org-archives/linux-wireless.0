Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:15893 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbbCOLhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 07:37:34 -0400
Message-ID: <55056EFB.9020100@broadcom.com> (sfid-20150315_123740_067023_877BE16A)
Date: Sun, 15 Mar 2015 12:37:31 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Ochal Christophe <christophe.ochal@gmail.com>
CC: Stefan Lippers-Hollmann <s.l-h@gmx.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom 43340
References: <550482A2.3080803@gmail.com>	<55048833.90408@broadcom.com>	<55048BB1.9080906@gmail.com>	<550491DA.6030105@broadcom.com>	<55049507.6040209@gmail.com> <20150314213907.3f1167bb@mir> <5504B29F.8000305@gmail.com>
In-Reply-To: <5504B29F.8000305@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/14/15 23:13, Ochal Christophe wrote:
> All,
>
> On 03/14/2015 09:39 PM, Stefan Lippers-Hollmann wrote:
>> You don't need to run windows for that, the nvram (calibration data,
>> probably the MAC address and related device specific data) is stored
>> in your mainboard's firmware - and exposed to userspace (under linux)
>> via /sys/firmware/efi/efivars/. You just need to identify the correct
>> file and copy it to a place where linux expects to find it
>> (/lib/firmware/brcm/brcmfmac43340-sdio.txt). Regards Stefan
>> Lippers-Hollmann
>
> Thanks for the hint, that did it, I'm online!

Apparently my hint was not clear enough. Good to hear it works for you.

Regards,
Arend
