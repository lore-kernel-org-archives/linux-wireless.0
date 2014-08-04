Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:62986 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaHDENI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2014 00:13:08 -0400
Received: by mail-pd0-f174.google.com with SMTP id fp1so8864869pdb.19
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2014 21:13:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2443fe2b84a649f8888072e45cea53e1@SIXPR01MB256.apcprd01.prod.exchangelabs.com>
References: <2443fe2b84a649f8888072e45cea53e1@SIXPR01MB256.apcprd01.prod.exchangelabs.com>
Date: Mon, 4 Aug 2014 09:43:07 +0530
Message-ID: <CAJwzM1=OC5VQMigJbe5AaYfJMSfhC5VngB6b2tQG=PKjGdyYRw@mail.gmail.com> (sfid-20140804_061312_672790_B56674B4)
Subject: Re: 80211ac support in 88W8897
From: Avinash Patil <avinashapatil@gmail.com>
To: Krishnankutty Plachikkattle
	<Krishnankutty_Plachikkattle@mindtree.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Krishnan,

Here is sample 11ac config file:

interface=uap0
driver=nl80211
ssid=mwifiex-11ac
hw_mode=a
channel=36
beacon_int=100
dtim_period=1
rts_threshold=2347
fragm_threshold=2346
auth_algs=1
send_probe_response=0
wmm_enabled=1
ieee80211n=1
ht_capab=[HT40+]
ieee80211ac=1
vht_oper_chwidth=1
vht_oper_centr_freq_seg0_idx=42

Thanks,
Avinash

On Thu, Jul 31, 2014 at 11:24 AM, Krishnankutty Plachikkattle
<Krishnankutty_Plachikkattle@mindtree.com> wrote:
> Hello Bing,
>
> I am trying to enable HT support for 88W8897  using hostapd 2.2.
> 80211n mode works well . Now I want to enable AC mode to improve throughput .
>
> Can you share a sample hostapd.conf  with  80211ac configuration.
>
> Thanks in advance,
>
> Regards,
> Krishnan.
>
> -----Original Message-----
> From: Bing Zhao [mailto:bzhao@marvell.com]
> Sent: Friday, May 30, 2014 6:16 AM
> To: Avinash Patil; Krishnankutty Plachikkattle; linux-wireless@vger.kernel.org
> Subject: RE: Support for 88W8897 in 3.10.17 kernel
>
>
>>>Is there any open source driver that supports  NFC and Bluetooth in this SoC?
>> Yes; btmrvl.ko and btusb.ko would support PCIe-USB8897 BT functionality.
>> Please check CONFIG_BT_MRVL kernel configuration parameter.
>
> Clarification:
> btmrvl driver only supports Bluetooth over SDIO (btmrvl_sdio). So it's for SD8897 cards only.
> The generic btusb driver works for PCIe-USB 8897 cards (Bluetooth is over USB).
>
> Regards,
> Bing
>
>> For NFC,  nfcmrvl.ko & nfcmrvl_usb.ko would support 8897 NFC functionality.
>> Please check for CONFIG_NFC_MRVL kernel configuration parameter.
>>
>> Thanks,
>> Avinash
>
>
> ________________________________
>
> http://www.mindtree.com/email/disclaimer.html
