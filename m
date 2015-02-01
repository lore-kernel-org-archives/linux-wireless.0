Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:43640 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbbBAEwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2015 23:52:51 -0500
Received: by mail-wg0-f49.google.com with SMTP id k14so33244732wgh.8
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2015 20:52:49 -0800 (PST)
Message-ID: <54CDB120.50002@gmail.com> (sfid-20150201_055327_856653_B34A9524)
Date: Sun, 01 Feb 2015 05:52:48 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Realtek RTL8812AE 802.11ac
References: <54CC73E2.3040208@gmail.com> <54CD1871.80409@lwfinger.net>
In-Reply-To: <54CD1871.80409@lwfinger.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31.01.2015 19:01, Larry Finger wrote:
> On 01/31/2015 12:19 AM, poma wrote:
>>
>> Salutem
>>
>>
>> Is the combination with Bluetooth only essential difference between RTL8821AE and RTL8812AE?
>>
>> *If* the undermentioned two devices are based on RTL8812AE chipset,
>> whether they supported via 'rtl8821ae.ko' & 'rtl8821aefw.bin'?
>>
>> PCIe RTL8812AE 802.11abgn+ac 2x2:2
>>
>>
>> Amped Wireless PCI20E (FCC ID: ZTT-PCI20E)
>>    https://wikidevi.com/wiki/Amped_Wireless_PCI20E
>>
>> - High Power AC1200 Wi-Fi PCI-E Adapter
>>    PCI20E
>>    http://www.ampedwireless.com/products/pci20e.html
>>
>> - http://www.amazon.com/Amped-Wireless-AC1200-Adapter-PCI20E/dp/B00I9AS1JA
>>
>>
>> D-Link DWA-582 rev A1 (FCC ID: KA2WA582A1)
>>    https://wikidevi.com/wiki/D-Link_DWA-582_rev_A1
>>
>> - Wireless AC1200 Dual Band PCIe Desktop Adapter
>>    DWA-582
>>    http://www.dlink.com.au/home-solutions/wireless-ac1200-dual-band-pcie-desktop-adapter
>>
>> - http://www.amazon.com/WIRELESS-AC1200-EXPRESS-ADAPTER-DUAL/dp/B00PHVQV14
> 
> Both RTL8812AE and RTL8821AE have wifi and Bluetooth. There is a difference in 
> the radio structure. The 8812 has the potential to handle 867 Mbps - the 8821 
> only half that rate. In any case, driver rtl8821ae handles both devices, and the 
> firmware is the same. One other difference is that I have not tested the 8812 as 
> I only have 8821 devices.
> 
> One other difference is that the firmware can handle BT coexistence internally 
> in the 8821, but not in the 8812. Realtek is still working on getting a method 
> of handling that problem. None of the Realtek Bluetooth adaptors has a driver in 
> the kernel. Fixing that issue is my current project.
> 
> Larry
> 

Sir, thanks a lot for response.


poma

