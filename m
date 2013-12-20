Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:58682 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab3LTMY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Dec 2013 07:24:58 -0500
Message-ID: <52B43718.504@broadcom.com> (sfid-20131220_132502_475674_AEF3A4AD)
Date: Fri, 20 Dec 2013 13:24:56 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	Naughtboy <skylvlinux@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bcm43236 complient in the compat-wireless-3.6.81???
References: <CAKH5=Lv=7CroQcx6x_JONnE+6mOTH1sLLcSxntGq2fogn-t4+Q@mail.gmail.com>	<52B2E638.8060906@hauke-m.de>	<CAKH5=LsaEw7GEHs5nb1omDeSMmcoFSXo8EEy+DeXvyXF5_1M_g@mail.gmail.com>	<52B300FC.7070204@hauke-m.de>	<52B31392.2070705@broadcom.com> <CACna6rwU8hroahpVsM7KTJD1iM2=12JuErr5LgCvswx+XsTjjA@mail.gmail.com>
In-Reply-To: <CACna6rwU8hroahpVsM7KTJD1iM2=12JuErr5LgCvswx+XsTjjA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2013 08:57 AM, Rafał Miłecki wrote:
> 2013/12/19 Arend van Spriel <arend@broadcom.com>:
>> It is in the kernel tree under
>> 'drivers/net/wireless/brcm80211/brcmfmac'. We only support rev 3 because
>> rev 2 and earlier do not have enough memory to run fullmac firmware.
>> However, I have not found any rev 3 on the market. If you have please
>> let me know.
> 
> Could you say something more about rev 2? How does it work with
> internal Broadcom driver? Is the firmware stored somewhere else? Does
> it have some another kind of memory?

It has a split-mac design. So at one end the spectrum there is
mac80211-type drivers and at the other side are fullmac drivers like
brcmfmac. rev 2 driver sits right in the middle of that with part of the
802.11 stack running on the host and part on the device. This device has
not enough memory to run the fullmac firmware.

Gr. AvS

> Apart from the firmware storing issue, is the communication between
> driver and hardware the same?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

