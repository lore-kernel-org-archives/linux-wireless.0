Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:43457 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2LJIBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 03:01:48 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so1600662wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 00:01:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <507FFC5D.7010108@hauke-m.de>
References: <1346348582-20095-1-git-send-email-arend@broadcom.com>
	<1346348582-20095-5-git-send-email-arend@broadcom.com>
	<507FFC5D.7010108@hauke-m.de>
Date: Mon, 10 Dec 2012 09:01:47 +0100
Message-ID: <CACna6rw6SO1_XbOJeG4WB1Evq7tHhH_KtrpoGkYz04sXHnGQPQ@mail.gmail.com> (sfid-20121210_090202_794778_10B18360)
Subject: Re: [PATCH 4/5] brcmfmac: Add 43143 USB support.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/10/18 Hauke Mehrtens <hauke@hauke-m.de>:
> On 08/30/2012 07:43 PM, Arend van Spriel wrote:
>> From: Hante Meuleman <meuleman@broadcom.com>
>>
>> Added usb device id to list of supported devices. 43143 is a new
>> 802.11n single stream device.
>>
>> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>>
>> +#define BRCMF_USB_43143_FW_NAME      "brcm/brcmfmac43143.bin"
>>  #define BRCMF_USB_43236_FW_NAME      "brcm/brcmfmac43236b.bin"
>>  #define BRCMF_USB_43242_FW_NAME      "brcm/brcmfmac43242a.bin"
>>
>
> Hi,
>
> when do you release the firmware for this devices to the public? I can
> not find it in linux-firmware or with a quick google search. I haven't
> found the brcmfmac43242a.bin firmware either.

Ping? The firmware seems to be still lacking.

-- 
Rafał
