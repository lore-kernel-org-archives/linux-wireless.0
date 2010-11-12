Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48073 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab0KLWNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 17:13:01 -0500
Received: by iwn10 with SMTP id 10so3971637iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 14:13:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CDDA103.3010209@lwfinger.net>
References: <AANLkTi=+0BOUaTs73jRMnJ=9qyNkqnBvMuKVTG4od9_+@mail.gmail.com>
	<0022152d6729673f6a0494b1f2e6@google.com>
	<AANLkTi=PYCwTtNmt9Baw=mYPqzyUQsiBNDOBXGic++5_@mail.gmail.com>
	<4CDAB99D.7030100@lwfinger.net>
	<AANLkTik9=-8bXNOvrY-JnFuVJr1wZG24o8m8JzJVD8tQ@mail.gmail.com>
	<4CDC049C.90005@lwfinger.net>
	<AANLkTi=JG=5tX2zcXOCdtUMHcASaZOWppZzb4vLyJSxc@mail.gmail.com>
	<4CDDA103.3010209@lwfinger.net>
Date: Fri, 12 Nov 2010 23:13:00 +0100
Message-ID: <AANLkTi=YcrfQyspBgWxwqD4AE-S26jmLtZKn6XmRHbxF@mail.gmail.com>
Subject: Re: Question about Edimax 7811Un
From: "miloofr@gmail.com" <miloofr@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you Larry. I successfully compiled the patched driver on a 64
bits system without any error. The driver loads, no freeze when
inserting the stick, however, there are a lot of timeout errors, as
shown below (the drivers seems to unload itself). That's why I guess a
"lshw -C network" does not show the wireless usb network.

Eric

Nov 12 23:12:26 grandsom kernel: [99800.313048]
Nov 12 23:12:26 grandsom kernel: [99800.313050] 8712_usb_endpoint_descriptor(0):
Nov 12 23:12:26 grandsom kernel: [99800.313054] bLength=7
Nov 12 23:12:26 grandsom kernel: [99800.313057] bDescriptorType=5
Nov 12 23:12:26 grandsom kernel: [99800.313060] bEndpointAddress=81
Nov 12 23:12:26 grandsom kernel: [99800.313063] wMaxPacketSize=200
Nov 12 23:12:26 grandsom kernel: [99800.313065] bInterval=0
Nov 12 23:12:26 grandsom kernel: [99800.313068]
Nov 12 23:12:26 grandsom kernel: [99800.313070] 8712_usb_endpoint_descriptor(1):
Nov 12 23:12:26 grandsom kernel: [99800.313073] bLength=7
Nov 12 23:12:26 grandsom kernel: [99800.313075] bDescriptorType=5
Nov 12 23:12:26 grandsom kernel: [99800.313078] bEndpointAddress=2
Nov 12 23:12:26 grandsom kernel: [99800.313081] wMaxPacketSize=200
Nov 12 23:12:26 grandsom kernel: [99800.313084] bInterval=0
Nov 12 23:12:26 grandsom kernel: [99800.313086]
Nov 12 23:12:26 grandsom kernel: [99800.313088] 8712_usb_endpoint_descriptor(2):
Nov 12 23:12:26 grandsom kernel: [99800.313091] bLength=7
Nov 12 23:12:26 grandsom kernel: [99800.313094] bDescriptorType=5
Nov 12 23:12:26 grandsom kernel: [99800.313096] bEndpointAddress=3
Nov 12 23:12:26 grandsom kernel: [99800.313099] wMaxPacketSize=200
Nov 12 23:12:26 grandsom kernel: [99800.313102] bInterval=0
Nov 12 23:12:26 grandsom kernel: [99800.313104]
Nov 12 23:12:26 grandsom kernel: [99800.313106] 8712_usb_endpoint_descriptor(3):
Nov 12 23:12:26 grandsom kernel: [99800.313109] bLength=7
Nov 12 23:12:26 grandsom kernel: [99800.313112] bDescriptorType=5
Nov 12 23:12:26 grandsom kernel: [99800.313114] bEndpointAddress=84
Nov 12 23:12:26 grandsom kernel: [99800.313117] wMaxPacketSize=40
Nov 12 23:12:26 grandsom kernel: [99800.313120] bInterval=1
Nov 12 23:12:26 grandsom kernel: [99800.313123] nr_endpoint=4,
in_num=2, out_num=2
Nov 12 23:12:26 grandsom kernel: [99800.313126]
Nov 12 23:12:26 grandsom kernel: [99800.313128] 8192cu: USB_SPEED_HIGH
Nov 12 23:12:26 grandsom kernel: [99800.313301] Chip Version ID:
VERSION_NORMAL_TSMC_CHIP_88C.
Nov 12 23:12:26 grandsom kernel: [99800.314046] EEPROM type is E-FUSE
Nov 12 23:12:26 grandsom kernel: [99800.314052] ====> ReadAdapterInfo8192C
Nov 12 23:12:26 grandsom kernel: [99800.314163] Boot from EFUSE,
Autoload Success !
Nov 12 23:12:26 grandsom kernel: [99800.323541]
rtw_efuse_get_max_phy_size...eeprompriv.efuse_phy_max_size(504)
Nov 12 23:12:26 grandsom kernel: [99800.822117] EEPROMVID = 0x7392
Nov 12 23:12:26 grandsom kernel: [99800.822123] EEPROMPID = 0x7811
Nov 12 23:12:26 grandsom kernel: [99800.822126] EEPROMCustomerID : 0x00
Nov 12 23:12:26 grandsom kernel: [99800.822130] EEPROMSubCustomerID: 0x00
Nov 12 23:12:26 grandsom kernel: [99800.822133] RT_CustomerID: 0x00
Nov 12 23:12:26 grandsom kernel: [99800.822137] RT_ChannelPlan: 0x02
Nov 12 23:12:26 grandsom kernel: [99800.822140] _ReadBoardType(0)
Nov 12 23:12:26 grandsom kernel: [99800.822143] ### AntDivCfg(0)
Nov 12 23:12:26 grandsom kernel: [99800.822147] BT Coexistance = disable
Nov 12 23:12:26 grandsom kernel: [99800.822152]
_ReadHWPDSelection...bHWPwrPindetect(0) bSupportRemoteWakeup(0)
Nov 12 23:12:26 grandsom kernel: [99800.822156] <==== ReadAdapterInfo8192C
Nov 12 23:12:26 grandsom kernel: [99800.822168] MAC Address from
efuse= 00:1f:1f:c7:8b:df
Nov 12 23:12:26 grandsom kernel: [99800.844971] +871x_drv - drv_open, bup=0
Nov 12 23:12:26 grandsom kernel: [99800.953013]  ===>
FirmwareDownload91C() fw:Rtl819XFwImageArray_TSMC
Nov 12 23:12:26 grandsom kernel: [99800.953030] fw_ver=v57,
fw_subver=0, sig=0x88c0
Nov 12 23:12:27 grandsom kernel: [99801.030141] reg 0x1fd4, usb write
TimeOut! status:-110 value=0x144e046
Nov 12 23:12:27 grandsom kernel: [99801.080149] reg 0x1fe4, usb write
TimeOut! status:-110 value=0x6f97901d
Nov 12 23:12:27 grandsom kernel: [99801.126605] fw download ok!
Nov 12 23:12:27 grandsom kernel: [99801.126612] Set RF Chip ID to
RF_6052 and RF type to 1T1R.
Nov 12 23:12:27 grandsom kernel: [99801.126617] rf_chip=0x4, rf_type=0x3
and/or
...
Nov 12 23:05:37 grandsom kernel: [99391.020266] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020268] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020271] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020273] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020275] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020278] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020280] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020283] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020285] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020288] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020290] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020292] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020295] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020297] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020300] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020302] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020305] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020307] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020309] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020312] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020314] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020317] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020319] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020322] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020324] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020327] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020329] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020331] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020334] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020336] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020339] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020341] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020344] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020377] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020379] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020382] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020384] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020386] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020389] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020391] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020394] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020396] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020398] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020401] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020403] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020406] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020408] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020410] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020413] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020415] reg 0x33, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020419] pdmpriv->TxPowerTrackControl = 1
Nov 12 23:05:37 grandsom kernel: [99391.020421] reg 0x40, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020424] reg 0x40, usb write
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020426] usb_write8...error(-19)
Nov 12 23:05:37 grandsom kernel: [99391.020428] reg 0xf0, usb read
TimeOut! status:-19 value=0x0
Nov 12 23:05:37 grandsom kernel: [99391.020431] reg 0x15, usb write
TimeOut! status:-19 value=0xe9
Nov 12 23:05:37 grandsom kernel: [99391.020432] usb_write8...error(-19)
Nov 12 23:05:37 grandsom kernel: [99391.020435] reg 0xf0, usb read
TimeOut! status:-19 value=0xe9
Nov 12 23:05:37 grandsom kernel: [99391.020438] MAC Address = 0-1f-1f-c7-8b-df
Nov 12 23:05:37 grandsom kernel: [99391.020471] -871x_drv - drv_open, bup=1
Nov 12 23:05:37 grandsom kernel: [99391.020693] ADDRCONF(NETDEV_UP):
wlan0: link is not ready
Nov 12 23:05:37 grandsom kernel: [99391.020711] (2)871x_drv -
drv_close, bup=1, hw_init_completed=1
Nov 12 23:05:37 grandsom kernel: [99391.020716] -871x_drv - drv_close, bup=1
Nov 12 23:05:37 grandsom kernel: [99391.029314] ###> rtw_cmd_thread
break.................
Nov 12 23:05:37 grandsom kernel: [99391.280874] +rtw_dev_unload
Nov 12 23:05:37 grandsom kernel: [99391.280884] reg 0x522, usb write
TimeOut! status:-19 value=0xff
Nov 12 23:05:37 grandsom kernel: [99391.280887] usb_write8...error(-19)
Nov 12 23:05:37 grandsom kernel: [99391.280890] reg 0xf0, usb read
TimeOut! status:-19 value=0xff
Nov 12 23:05:37 grandsom kernel: [99391.280892] usb_read_port_cancel
Nov 12 23:05:37 grandsom kernel: [99391.280894] usb_read_port_cancel
Nov 12 23:05:37 grandsom kernel: [99391.280896] -rtw_dev_unload
Nov 12 23:05:37 grandsom kernel: [99391.280897] +r871xu_dev_remove,
hw_init_completed=1


2010/11/12 Larry Finger <Larry.Finger@lwfinger.net>:
> Eric,
>
> Attached is a patch that compiles cleanly on a 64-bit system. I have not tested
> it as I have no device.
>
> There are two kinds of differences between 32- and 64-bit systems. The first is
> the size of a pointer, which becomes important whenever there is a need to keep
> one as an integer. The original driver stores them into a u32 or a uint, which
> is too short. These problems are solved by storing such values in variables of
> __kernel_size_t. The second problem occurs for the communication buffers. There
> are 4 quantities: head, data, tail and end. For both 32- and 64-bit systems,
> head and data are pointers. With 32 bits, so are tail and end, but for 64 bits,
> tail and end are uint.
>
> I got all the ones the compiler complained about.
>
> Larry
>
>
