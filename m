Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sr03-09.mta.terra.com.br ([200.154.152.48]:38227 "EHLO
	sr03-09.mta.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbYJ1B1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 21:27:43 -0400
Message-ID: <49066A8F.7030708@terra.com.br> (sfid-20081028_022748_391793_E5ED2636)
Date: Mon, 27 Oct 2008 23:27:43 -0200
From: Piter PUNK <piterpk@terra.com.br>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8187B transmit problems
References: <49041DAE.1060206@terra.com.br> <49050BC7.1010609@lwfinger.net>	<49051E0E.2030909@terra.com.br> <4905F59B.9030107@lwfinger.net>
In-Reply-To: <4905F59B.9030107@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Piter PUNK wrote:
>> This is the built-in rtl8187b adapter:
>>
>> usb 1-1: new high speed USB device using ehci_hcd and address 7
>> usb 1-1: configuration #1 chosen from 1 choice
>> usb 1-1: New USB device found, idVendor=0bda, idProduct=8189
>> usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>> usb 1-1: Product: RTL8187B_WLAN_Adapter
>> usb 1-1: Manufacturer: Manufacturer_Realtek
>> usb 1-1: SerialNumber: 00e04c000001
>> rtl8187: 8187B chip detected. Support is EXPERIMENTAL, and could damage
>> your
>>          hardware, use at your own risk
>> phy3: Selected rate control algorithm 'pid'
>> phy3: hwaddr 00:16:44:aa:df:bf, RTL8187BvE V0 + rtl8225z2
>
> 
> My device is a little different that yours:
> 
> rtl8187: 8187B chip detected. Support is EXPERIMENTAL, and could damage your
>          hardware, use at your own risk
> rtl8187: inconsistency between id with OEM info!
> phy1: Selected rate control algorithm 'pid'
> phy1: hwaddr 00:11:6b:3e:c4:0a, RTL8187BvB(early) V0 + rtl8225z2
> 
> I'll review the code to look at the differences in paths for your device and
> mine. Just in case there is a data dependency, please send me (privately) your
> 2048 byte file.

Is an all zeroed file: dd if=/dev/zero of=file2048 count=2048 bs=1
Data is independent and, maybe, I can transmit something between 1024
and 2048 bytes; not tested yet. I only begin those tests with files with
different sizes to "see" why I can connect with SSH, browse in web,
download my mails... and can't send mail, upload files or fill web
forms.

Feel free to suggest other tests. I have many wireless devices and
access points available to test.

Thanks!

Piter PUNK
-- 
     |        E-Mail: piterpk@terra.com.br
    .|.
    /V\
   // \\      UIN:116043354  Homepage:http://piterpunk.info02.com.br
  /(   )\
   ^`~'^         ----> Slackware Linux <----
  #105432
