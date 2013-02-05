Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:38606 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab3BETzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 14:55:45 -0500
Received: by mail-wg0-f52.google.com with SMTP id 12so464643wgh.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2013 11:55:43 -0800 (PST)
Message-ID: <511163BA.7060902@gmail.com> (sfid-20130205_205550_242700_4DE10333)
Date: Tue, 05 Feb 2013 20:55:38 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Thomas Rosenkranz <tom.rosary@googlemail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: FW: 0bda:819a RTL8188CUS WLAN doesn't work out of the box in
 downstream and upstreamkernel
References: <51102B22.20702@gmail.com> <CAOAX8-k-Nbx4Om8fkEHRW2jmZCxKpsMY6oEZMAvdEQpXWn9Mdw@mail.gmail.com>
In-Reply-To: <CAOAX8-k-Nbx4Om8fkEHRW2jmZCxKpsMY6oEZMAvdEQpXWn9Mdw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2013 12:00 AM, Thomas Rosenkranz wrote:

Larry, are you able to identify the chip of that device
with the 8192cu output ?

what should he do ? open the device to see the chip ??

>     [  183.369324] rtw driver version=v3.4.4_xxxx.20120730
>     [  183.369330] Build at: Feb  4 2013 23:44:44
>     [  183.369400] usbcore: registered new interface driver rtl8192cu
>     [  183.370696] register rtw_netdev_ops to netdev_ops
>     [  183.370702] CHIP TYPE: RTL8188C_8192C
>     [  183.370706]
>     [  183.370707] usb_endpoint_descriptor(0):
>     [  183.370710] bLength=7
>     [  183.370711] bDescriptorType=5
>     [  183.370713] bEndpointAddress=81
>     [  183.370715] wMaxPacketSize=200
>     [  183.370717] bInterval=0
>     [  183.370719] RT_usb_endpoint_is_bulk_in = 1
>     [  183.370721]
>     [  183.370722] usb_endpoint_descriptor(1):
>     [  183.370724] bLength=7
>     [  183.370726] bDescriptorType=5
>     [  183.370727] bEndpointAddress=2
>     [  183.370729] wMaxPacketSize=200
>     [  183.370731] bInterval=0
>     [  183.370733] RT_usb_endpoint_is_bulk_out = 2
>     [  183.370735]
>     [  183.370736] usb_endpoint_descriptor(2):
>     [  183.370738] bLength=7
>     [  183.370739] bDescriptorType=5
>     [  183.370741] bEndpointAddress=3
>     [  183.370743] wMaxPacketSize=200
>     [  183.370744] bInterval=0
>     [  183.370746] RT_usb_endpoint_is_bulk_out = 3
>     [  183.370748]
>     [  183.370749] usb_endpoint_descriptor(3):
>     [  183.370751] bLength=7
>     [  183.370752] bDescriptorType=5
>     [  183.370754] bEndpointAddress=84
>     [  183.370756] wMaxPacketSize=40
>     [  183.370758] bInterval=1
>     [  183.370760] RT_usb_endpoint_is_int_in = 4, Interval = 1
>     [  183.370762] nr_endpoint=4, in_num=2, out_num=2
>     [  183.370764]
>     [  183.370765] USB_SPEED_HIGH
>     [  183.370905] Chip Version ID: VERSION_NORMAL_TSMC_CHIP_88C.
>     [  183.370912] RF_Type is 3!!
>     [  183.371259] EEPROM type is E-FUSE
>     [  183.371263] ====> ReadAdapterInfo8192C
>     [  183.371385] Boot from EFUSE, Autoload OK !
>     [  183.556146] EEPROMVID = 0x0bda
>     [  183.556150] EEPROMPID = 0x819a
>     [  183.556152] EEPROMCustomerID : 0x00
>     [  183.556154] EEPROMSubCustomerID: 0x00
>     [  183.556156] RT_CustomerID: 0x00
>     [  183.556159] _ReadMACAddress MAC Address from EFUSE = 00:1c:7b:a8:a8:f3
>     [  183.556163] EEPROMRegulatory = 0x1
>     [  183.556165] _ReadBoardType(3)
>     [  183.556167] BT Coexistance = disable
>     [  183.556170] RT_ChannelPlan: 0x0a
>     [  183.556172] _ReadPSSetting...bHWPwrPindetect(0)-bHWPowerdown(10) ,bSupportRemoteWakeup(0)
>     [  183.556176] ### PS params=>  power_mgnt(1),usbss_enable(0) ###
>     [  183.556178] ### AntDivCfg(0)
>     [  183.556180] readAdapterInfo_8192CU(): REPLACEMENT = 1
>     [  183.556184] <==== ReadAdapterInfo8192C in 184 ms
>     [  183.556432] rtw_macaddr_cfg MAC Address  = 00:1c:7b:a8:a8:f3
>     [  183.556436] MAC Address from pnetdev->dev_addr= 00:1c:7b:a8:a8:f3
>     [  183.557231] bDriverStopped:1, bSurpriseRemoved:0, bup:0, hw_init_completed:0
>     [  183.571360] bDriverStopped=1
>     [  183.572190] +871x_drv - drv_open, bup=0
>     [  183.576780]  ===> FirmwareDownload91C() fw:Rtl819XFwImageArray_TSMC
>     [  183.576786] FirmwareDownload92C accquire FW from embedded image
>     [  183.576790] fw_ver=v80, fw_subver=0, sig=0x88c0
>     [  183.608627] fw download ok!
>     [  183.608631] Set RF Chip ID to RF_6052 and RF type to 1T1R.
>     [  183.984930] IQK:Start!!!
>     [  183.996309] Path A IQK Success!!
>     [  184.004034] Path A IQK Success!!
>     [  184.008907] IQK: final_candidate is 0
>     [  184.008911] IQK: RegE94=ff RegE9C=d RegEA4=fd RegEAC=3fd RegEB4=0 RegEBC=0 RegEC4=0 RegECC=0
>     [  184.008914]  Path A IQ Calibration Success !
>     [  184.122503] pdmpriv->TxPowerTrackControl = 1
>     [  184.127472] MAC Address from REG_MACID = 00:1c:7b:a8:a8:f3
>     [  184.127476] rtl8192cu_hal_init in 556ms
>     [  184.127480] MAC Address = 00:1c:7b:a8:a8:f3
>     [  184.132257] -871x_drv - drv_open, bup=1
>     [  184.133354] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>     [  184.133824] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>     [  184.133854] set_mode = IW_MODE_INFRA
>     [  184.150748] [rtw_wx_set_pmkid] IW_PMKSA_FLUSH!
>     [  184.150763] set_mode = IW_MODE_INFRA
>     [  184.193691] [rtw_wx_set_pmkid] IW_PMKSA_FLUSH!
>     [  185.543612] survey done event(25)
>     [  185.593007] IW_SCAN_THIS_ESSID, ssid=nicht dein WLAN, len=15
>     [  186.942758] survey done event(2d)
>     [  186.943996] wpa_set_auth_algs, AUTH_ALG_OPEN_SYSTEM
>     [  186.944003] set_mode = IW_MODE_INFRA
>     [  186.944019]
>     [  186.944020]  wpa_ie(length:22):
>     [  186.944024] 0x30 0x14 0x01 0x00 0x00 0x0f 0xac 0x02
>     [  186.944028] 0x01 0x00 0x00 0x0f 0xac 0x04 0x01 0x00
>     [  186.944031] 0x00 0x0f 0xac 0x02 0x00 0x00 0x00 0x00
>     [  186.944045] =>rtw_wx_set_essid
>     [  186.944047] ssid=nicht dein WLAN, len=15
>     [  186.944052] Set SSID under fw_state=0x00000008
>     [  186.944058] [by_bssid:0][assoc_ssid:nicht dein WLAN][to_roaming:0] new candidate: nicht dein WLAN(00:15:0c:f1:0d:d0) rssi:-32
>     [  186.944077] rtw_select_and_join_from_scanned_queue: candidate: nicht dein WLAN(00:15:0c:f1:0d:d0)
>     [  186.944090] link to new AP
>     [  186.944100] <=rtw_wx_set_essid, ret 0
>     [  186.944110] Set BSSID under fw_state=0x00000088
>     [  187.125476] link to new AP
>     [  187.125484] issue_deauth to 00:15:0c:f1:0d:d0
>     [  187.129338] OnAuthClient
>     [  187.129349] network.SupportedRates[0]=82
>     [  187.129351] network.SupportedRates[1]=84
>     [  187.129353] network.SupportedRates[2]=8B
>     [  187.129356] network.SupportedRates[3]=96
>     [  187.129358] network.SupportedRates[4]=2C
>     [  187.129360] network.SupportedRates[5]=0C
>     [  187.129362] network.SupportedRates[6]=12
>     [  187.129364] network.SupportedRates[7]=18
>     [  187.129366] network.SupportedRates[8]=24
>     [  187.129368] network.SupportedRates[9]=30
>     [  187.129370] network.SupportedRates[10]=48
>     [  187.129372] network.SupportedRates[11]=60
>     [  187.129374] network.SupportedRates[12]=6C
>     [  187.129377] issue_assocreq(): the rate[4]=2C is not supported by STA!
>     [  187.129380] bssrate_len = 12
>     [  187.135954] OnAssocRsp
>     [  187.135977] report_join_res(1)
>     [  187.135983] rtw_joinbss_update_network
>     [  187.135994] rtw_joinbss_update_stainfo
>     [  187.136060] HW_VAR_BASIC_RATE: BrateCfg(0x15d)
>     [  187.137196] HTOnAssocRsp
>     [  187.137334] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>     [  187.142408] update raid entry, mask=0x40000fff, arg=0x80
>     [  187.143905] rtl8192c_set_FwJoinBssReport_cmd mstatus(1)
>     [  187.144776] SetFwRsvdPagePkt
>     [  187.144787] Set RSVD page location to Fw.
>     [  187.145453]
>     [  187.145455]  ~~~~stastakey:unicastkey
>     [  187.145524]
>     [  187.145525]  ~~~~stastakey:groupkey
>     [  187.145529] ==> rtw_set_key algorithm(2),keyid(2),key_mask(4)
>     [  187.145903] =>mlmeext_joinbss_event_callback
>     [  187.811595] rx bc/mc packets, to perform sw rtw_tkip_decrypt
>     [  188.141761] rtl8192c_dm_RF_Saving(): RF_Save
>     [  197.538636] wlan0: no IPv6 routers present


>     tommy@Tommy-AIO:~$ lsusb -v -d 0bda:819a
> 
>     Bus 001 Device 006: ID 0bda:819a Realtek Semiconductor Corp.
>     Couldn't open device, some information will be missing
>     Device Descriptor:
>       bLength                18
>       bDescriptorType         1
>       bcdUSB               2.00
>       bDeviceClass            0 (Defined at Interface level)
>       bDeviceSubClass         0
>       bDeviceProtocol         0
>       bMaxPacketSize0        64
>       idVendor           0x0bda Realtek Semiconductor Corp.
>       idProduct          0x819a
>       bcdDevice            2.00
>       iManufacturer           1
>       iProduct                2
>       iSerial                 3
>       bNumConfigurations      1
>       Configuration Descriptor:
>         bLength                 9
>         bDescriptorType         2
>         wTotalLength           46
>         bNumInterfaces          1
>         bConfigurationValue     1
>         iConfiguration          0
>         bmAttributes         0xa0
>           (Bus Powered)
>           Remote Wakeup
>         MaxPower              500mA
>         Interface Descriptor:
>           bLength                 9
>           bDescriptorType         4
>           bInterfaceNumber        0
>           bAlternateSetting       0
>           bNumEndpoints           4
>           bInterfaceClass       255 Vendor Specific Class
>           bInterfaceSubClass    255 Vendor Specific Subclass
>           bInterfaceProtocol    255 Vendor Specific Protocol
>           iInterface              0
>           Endpoint Descriptor:
>             bLength                 7
>             bDescriptorType         5
>             bEndpointAddress     0x81  EP 1 IN
>             bmAttributes            2
>               Transfer Type            Bulk
>               Synch Type               None
>               Usage Type               Data
>             wMaxPacketSize     0x0200  1x 512 bytes
>             bInterval               0
>           Endpoint Descriptor:
>             bLength                 7
>             bDescriptorType         5
>             bEndpointAddress     0x02  EP 2 OUT
>             bmAttributes            2
>               Transfer Type            Bulk
>               Synch Type               None
>               Usage Type               Data
>             wMaxPacketSize     0x0200  1x 512 bytes
>             bInterval               0
>           Endpoint Descriptor:
>             bLength                 7
>             bDescriptorType         5
>             bEndpointAddress     0x03  EP 3 OUT
>             bmAttributes            2
>               Transfer Type            Bulk
>               Synch Type               None
>               Usage Type               Data
>             wMaxPacketSize     0x0200  1x 512 bytes
>             bInterval               0
>           Endpoint Descriptor:
>             bLength                 7
>             bDescriptorType         5
>             bEndpointAddress     0x84  EP 4 IN
>             bmAttributes            3
>               Transfer Type            Interrupt
>               Synch Type               None
>               Usage Type               Data
>             wMaxPacketSize     0x0040  1x 64 bytes
>             bInterval               1
