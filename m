Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from correio.ufra.edu.br ([200.129.150.6]:41790 "EHLO
	correio.ufra.edu.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZIAUCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 16:02:23 -0400
Received: from localhost (localhost [127.0.0.1])
	by correio.ufra.edu.br (Postfix) with ESMTP id 374417A48B
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2009 17:04:53 -0300 (BRT)
Received: from correio.ufra.edu.br ([127.0.0.1])
	by localhost (correio.ufra.edu.br [127.0.0.1]) (amavisd-new, port 10025)
	with LMTP id z6ivleit2sKs for <linux-wireless@vger.kernel.org>;
	Tue,  1 Sep 2009 17:04:45 -0300 (BRT)
Received: from [10.10.17.60] (srv2.ufra.edu.br [200.129.150.5])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by correio.ufra.edu.br (Postfix) with ESMTP id 85A927A48A
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2009 17:04:45 -0300 (BRT)
Message-ID: <4A9D7DC0.6050701@ufra.edu.br>
Date: Tue, 01 Sep 2009 17:02:08 -0300
From: "Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: zd1211rw on ppc (iBook G4)
References: <4A9BFCCB.6040808@ufra.edu.br>	 <3ace41890908311025r3ce83c12gd6aeace4833609b1@mail.gmail.com>	 <4A9C0ADC.6050607@ufra.edu.br> <3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com>
In-Reply-To: <3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some more diagnostic info for the rw driver, this time compiled as
built-in and debug option in the kernel for 2.6.30.

dmesg for rw driver output:
usb 1-2: new high speed USB device using ehci_hcd and address 2
usb 1-2: New USB device found, idVendor=0411, idProduct=00da
usb 1-2: New USB device strings: Mfr=16, Product=32, SerialNumber=0
usb 1-2: Product: USB2.0 WLAN
usb 1-2: Manufacturer: Buffalo
usb 1-2: configuration #1 chosen from 1 choice
usb 1-2: print_id() 0411:00da v4810 high
usb 1-2: reset high speed USB device using ehci_hcd and address 2
zd1211rw 1-2:1.0: zd_chip_read_mac_addr_fw()
phy0: Selected rate control algorithm 'minstrel'
zd1211rw 1-2:1.0: probe() successful
zd1211rw 1-2:1.0: phy0
zd1211rw 1-2:1.0: zd_usb_init_hw()
usb 1-2: request_fw_file() fw name zd1211/zd1211b_ub
usb 1-2: firmware: requesting zd1211/zd1211b_ub
usb 1-2: upload_firmware() firmware device id 0x4810 is equal to the
actual device id
usb 1-2: request_fw_file() fw name zd1211/zd1211b_uphr
usb 1-2: firmware: requesting zd1211/zd1211b_uphr
usb 1-2: upload_code() transfer size 4096
usb 1-2: upload_code() transfer size 1024
usb 1-2: upload_code() firmware confirm return value 0x01
zd1211rw 1-2:1.0: zd_usb_enable_int()
zd1211rw 1-2:1.0: zd_usb_enable_int() submit urb ce577580
zd1211rw 1-2:1.0: zd_chip_init_hw()
zd1211rw 1-2:1.0: dump_cr() CR_AFTER_PNP 0x00000000
zd1211rw 1-2:1.0: dump_cr() CR_GPI_EN 0x00000000
zd1211rw 1-2:1.0: dump_cr() CR_INTERRUPT 0x00000000
zd1211rw 1-2:1.0: read_fw_regs_offset() fw_regs_base: 0xf7f1
zd1211rw 1-2:1.0: read_pod() E2P_POD 0xa000011a
zd1211rw 1-2:1.0: read_pod() RF AL2230S_RF 0xa PA type 0x0 patch CCK 1
patch CR157 0 patch 6M 0 new PHY 1 link LED1 tx led 1
zd1211rw 1-2:1.0: hw_init()
zd1211rw 1-2:1.0: zd1211b_hw_reset_phy()
zd1211rw 1-2:1.0: zd1211b_hw_init_hmac()
zd1211rw 1-2:1.0: zd_usb_rfwrite() value 0x0241000 bits 24
zd1211rw 1-2:1.0: firmware version 4725
zd1211rw 1-2:1.0: dump_fw_registers() FW_FIRMWARE_VER 0x4725
zd1211rw 1-2:1.0: dump_fw_registers() FW_USB_SPEED 0x0001
zd1211rw 1-2:1.0: dump_fw_registers() FW_FIX_TX_RATE 0x0000
zd1211rw 1-2:1.0: dump_fw_registers() FW_LINK_STATUS 0x0000
zd1211rw 1-2:1.0: dump_cr() CR_AFTER_PNP 0x00000001
zd1211rw 1-2:1.0: dump_cr() CR_GPI_EN 0x00000000
zd1211rw 1-2:1.0: dump_cr() CR_INTERRUPT 0x00000000
zd1211rw 1-2:1.0: zd1211b chip 0411:00da v4810 high 00-16-01 AL2230S_RF
pa0 g--N-
zd1211rw 1-2:1.0: zd_read_regdomain() regdomain: 0x49
zd1211rw 1-2:1.0: zd_usb_disable_int() urb ce577580 killed
zd1211rw 1-2:1.0: zd_usb_init_hw() couldn't initialize mac. Error number 1

iwconfig:
lo        no wireless extensions.

eth0      no wireless extensions.

tunl0     no wireless extensions.

gre0      no wireless extensions.

wmaster0  no wireless extensions.

wlan0     IEEE 802.11bg  ESSID:"" 
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated  
          Tx-Power=0 dBm  
          Retry min limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0



Hin-Tak Leung wrote:
> I have a bunch of patches which bring the 2.22 vendor driver up to
> 2.6.29 and 3.0 the vendor driver up to 2.6.30:
> http://htl10.users.sourceforge.net/patchsets/
> It doesn't fix the rw driver, but might be good enough for you?
>   

I have downloaded the vendor driver and applied your patchset.

Inserted the vendor  { USB_DEVICE(0x0411, 0x00DA) }, in
ar2524drv/src/zdusb.c

Recompiled as zd1211REV_B

dmesg for vendor driver:
udev: starting version 145

 _____     ____    _    ____
|__  /   _|  _ \  / \  / ___|
  / / | | | | | |/ _ \ \___ \
 / /| |_| | |_| / ___ \ ___) |
/____\__, |____/_/   \_\____/
     |___/
zd1211 - version 3.0.0.56
vendor_id = 0411
product_id = 00da
USB 2.0 Host
Release Ver = 4810
EEPORM Ver = 4330
Finsih download Firmware. Ready to reboot
Finsih download Firmware. Ready to reboot
Finsih download Firmware. Ready to reboot
ohci1394 0002:20:0e.0: enabling device (0000 -> 0002)
zd1211_USB_PACKAGE_READ_REGISTER: warning, restarting INT EP
zd1211_readl retry OK
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[40] 
MMIO=[f5000000-f50007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
PA type: 2
Airoha AL2230S_RF
Overwrite CR157 = 0x0
Overwrite CR47 = 0x10019
zd1205_config: EEP(HWFeature)=0xF7D0
AllowedChannel = 00013fff
Region:0
zd1211_USB_PACKAGE_READ_REGISTER: warning, restarting INT EP
zd1211_readl retry OK
usbcore: registered new interface driver zd1211


I am able to do iwlist ath0 scanning, a list of acess point appears but
sometimes this fails.
iwlist ath0 scanning:
ath0      Scan completed :
          Cell 01 - Address: 00:21:91:0E:0B:F7
                    ESSID:"adminWF10"
                    Mode:Master
                    Frequency=2.412 GHz (Channel 1)
                    Quality=46/100  Signal level=-74 dBm  Noise
level=-96 dBm
                    Encryption key:off
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              12 Mb/s; 24 Mb/s; 36 Mb/s; 9 Mb/s; 18 Mb/s
                              48 Mb/s; 54 Mb/s
                    Extra:bcn_int=100
          Cell 02 - Address: 00:1D:0F:D1:4D:D2
                    ESSID:"LGAA_P_CENTRAL_WF01"
                    Mode:Master
                    Frequency=2.437 GHz (Channel 6)
                    Quality=43/100  Signal level=-76 dBm  Noise
level=-96 dBm
                    Encryption key:off
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              12 Mb/s; 24 Mb/s; 36 Mb/s; 9 Mb/s; 18 Mb/s
                              48 Mb/s; 54 Mb/s
                    Extra:bcn_int=100
          Cell 03 - Address: 00:1B:11:87:A7:0C
                    ESSID:"ponto-acesso-mutsuo"
                    Mode:Master
                    Frequency=2.437 GHz (Channel 6)
                    Quality=43/100  Signal level=-76 dBm  Noise
level=-96 dBm
                    Encryption key:off
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
                              48 Mb/s; 54 Mb/s
                    Extra:bcn_int=100


Scan again, it fails and works seemingly in an unknown manner.
iwlist ath0 scanning
ath0      Failed to read scan data : Resource temporarily unavailable


Some message in dmesg of relevance:
...
zd1211_USB_PACKAGE_READ_REGISTER: warning, restarting INT EP
zd1211_readl retry OK
zd1211_USB_PACKAGE_READ_REGISTER: warning, restarting INT EP
zd1211_readl retry OK
zd1211_USB_PACKAGE_READ_REGISTER: warning, restarting INT EP
zd1211_readl retry OK
zd1211_USB_PACKAGE_READ_REGISTER: warning, restarting INT EP
zd1211_readl retry OK
....(many times over)

and

1211_readl failed for 5 attempts...Very Serious<3>1211_readl failed for
5 attempts...Very Serious<3>1211_readl failed for 5 attempts...Very
Serious<3>1211_readl failed for 5 attempts...Very Serious<3>1211_readl
failed for 5 attempts...Very Serious<3>1211_readl failed for 5
attempts...Very Serious<3>1211_readl failed for 5 attempts...Very
Serious<3>1211_readl failed for 5 attempts...Very Serious<3>1211_readl
failed for 5 attempts...Very Serious<3>1211_readl failed for 5
attempts...Very Serious<3>1211_readl failed for 5 attempts...Very
Serious<3>1211_readl failed for 5 attempts...Very Serious<3>1211_readl
failed for 5 attempts...Very Serious<3>1211_readl failed for 5
attempts...Very Serious<3>1211_readl failed for 5 attempts...Very
Serious<7>zd1205_notify_disjoin_event

Giving up .... for now.


Regards,
 
Leonardo

