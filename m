Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:63155 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab0DEDn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Apr 2010 23:43:27 -0400
Received: by fxm27 with SMTP id 27so734965fxm.28
        for <linux-wireless@vger.kernel.org>; Sun, 04 Apr 2010 20:43:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <s2i917a57cb1004042012xeff52c8fl93eab97c1290088b@mail.gmail.com>
References: <u2u917a57cb1004030656w7aff9e18qa43a358674d52d5a@mail.gmail.com>
	<4BB7660A.3030900@lwfinger.net> <i2x917a57cb1004030949qabd49dfeqa1f7cb66f4ef0f4e@mail.gmail.com>
	<4BB773A9.2070703@lwfinger.net> <u2o3ace41891004031720ha68d9367m4be78c2a5d850f89@mail.gmail.com>
	<w2v917a57cb1004041753ne6ba8c03i5b927e52a107457a@mail.gmail.com>
	<m2j69e28c911004041850p6c0f9b41l2604ab6f13fa9e1e@mail.gmail.com>
	<s2i917a57cb1004042012xeff52c8fl93eab97c1290088b@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 5 Apr 2010 05:43:04 +0200
Message-ID: <j2o69e28c911004042043md1955827nf6ea3dff2fdc458d@mail.gmail.com>
Subject: Re: RTL 8187b - naughty behaviour
To: Rogerio Luz Coelho <rogluz.news@gmail.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/5 Rogerio Luz Coelho <rogluz.news@gmail.com>:
> 2010/4/4 Gábor Stefanik <netrolller.3d@gmail.com>:
>> On Mon, Apr 5, 2010 at 2:53 AM, Rogerio Luz Coelho
>> <rogluz.news@gmail.com> wrote:
>>> 2010/4/3 Hin-Tak Leung <hintak.leung@gmail.com>:
>>>> On Sat, Apr 3, 2010 at 5:58 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>>> <snipped>
>>>>> What is the exact make and model of the device? It might be difficult
>>>>> for me to get one in the US, but one of the rtl8187 developers lives in
>>>>> Brazil. He should be able to find one.
>>>
>>> I think I sent it, but if I didn't it is a
>>>
>>> Positivo Premium R430L Core 2 Duo 4GB machine
>>>
>>> Rogerio
>>
>> No, that is your computer. What Hin-Tak is asking for is the wireless
>> adapter's model.
>>
>>>
>>>
>>>> Herton might be able to get the exact model/etc from Brazil so it is
>>>> worth providing the vendor details.
>
> here goes lsusb -v of the device
>
> Bus 001 Device 002: ID 0bda:8189 Realtek Semiconductor Corp. RTL8187B
> Wireless 802.11g 54Mbps Network Adapter
> Device Descriptor:
>  bLength                18
>  bDescriptorType         1
>  bcdUSB               2.00
>  bDeviceClass            0 (Defined at Interface level)
>  bDeviceSubClass         0
>  bDeviceProtocol         0
>  bMaxPacketSize0        64
>  idVendor           0x0bda Realtek Semiconductor Corp.
>  idProduct          0x8189 RTL8187B Wireless 802.11g 54Mbps Network
> Adapter
>  bcdDevice            2.00
>  iManufacturer           1
>  iProduct                2
>  iSerial                 3
>  bNumConfigurations      1
>  Configuration Descriptor:
>    bLength                 9
>    bDescriptorType         2
>    wTotalLength           81
>    bNumInterfaces          1
>    bConfigurationValue     1
>    iConfiguration          4
>    bmAttributes         0x80
>      (Bus Powered)
>    MaxPower              500mA
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        0
>      bAlternateSetting       0
>      bNumEndpoints           9
>      bInterfaceClass       255 Vendor Specific Class
>      bInterfaceSubClass    255 Vendor Specific Subclass
>      bInterfaceProtocol    255 Vendor Specific Protocol
>      iInterface              2
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x83  EP 3 IN
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0200  1x 512 bytes
>        bInterval               0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x04  EP 4 OUT
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0200  1x 512 bytes
>        bInterval               0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x05  EP 5 OUT
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0200  1x 512 bytes
>        bInterval               0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x06  EP 6 OUT
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0200  1x 512 bytes
>        bInterval               0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x07  EP 7 OUT
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0200  1x 512 bytes
>        bInterval               0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x89  EP 9 IN
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0200  1x 512 bytes
>        bInterval               0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x0a  EP 10 OUT
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0200  1x 512 bytes
>        bInterval               0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x0b  EP 11 OUT
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0200  1x 512 bytes
>        bInterval               0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x0c  EP 12 OUT
>        bmAttributes            2
>          Transfer Type            Bulk
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0200  1x 512 bytes
>        bInterval               0
> can't get device qualifier: Operation not permitted
> can't get debug descriptor: Operation not permitted
> cannot read device status, Operation not permitted (1)
>
> Can't find details in the Computer-vendor's site ... hope this
> information sufices, or I'll have to open up the box, and there goes
> my waranty ;)
>
> Rogerio
>

Is this an internal wireless card?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
