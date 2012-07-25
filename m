Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm16-vm0.bullet.mail.ird.yahoo.com ([77.238.189.192]:46607 "HELO
	nm16-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750789Ab2GYRZG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 13:25:06 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <CAKjQTCex5oXLkPOZeoccT5a0CxMDpdpmSqcJy4SV7h1eaeo=pA@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EE086.6000304@lwfinger.net> <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com>
Message-ID: <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> (sfid-20120725_192510_862610_18064C5E)
Date: Wed, 25 Jul 2012 18:25:04 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Forgot to give new outputs: (sorry for the spam)

modinfo rtl8192ce
filename:       /lib/modules/3.2.23-030223-generic/kernel/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192ce.ko

firmware:       rtlwifi/rtl8192cfwU_B.bin
firmware:       rtlwifi/rtl8192cfwU.bin
firmware:       rtlwifi/rtl8192cfw.bin
description:    Realtek 8192C/8188C 802.11n PCI wireless
license:        GPL
author:         Larry Finger    <Larry.Finger@lwfinger.net>
author:         Realtek WlanFAE <wlanfae@realtek.com>
author:         lizhaoming      <chaoming_li@realsil.com.cn>
srcversion:     216E9AAB4459E49C3C6B69A
alias:          pci:v000010ECd00008176sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008177sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008178sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008191sv*sd*bc*sc*i*
depends:        rtlwifi,rtl8192c-common,mac80211
intree:         Y
vermagic:       3.2.23-030223-generic SMP mod_unload modversions 686 
parm:           swenc:Set to 1 for software crypto (default 0)
parm:           ips:Set to 0 to not use link power save (default 1)

parm:           swlps:Set to 1 to use SW control power save (default 0)

parm:           fwlps:Set to 1 to use FW control power save (default 1)

parm:           debug:Set debug level (0-5) (default 0) (int)


ifconfig 
br0       Link encap:Ethernet  HWaddr 80:ee:73:31:54:b2  
          inet addr:192.168.0.40  Bcast:192.168.0.255  Mask:255.255.255.0
          inet6 addr: fe80::82ee:73ff:fe31:54b2/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:24794 errors:0 dropped:0 overruns:0 frame:0
          TX packets:19284 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1968234 (1.9 MB)  TX bytes:24388301 (24.3 MB)

eth0      Link encap:Ethernet  HWaddr 80:ee:73:31:54:b2  
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:26859 errors:0 dropped:175 overruns:0 frame:0
          TX packets:19205 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:2731919 (2.7 MB)  TX bytes:24381151 (24.3 MB)
          Interrupt:45 

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:8258 errors:0 dropped:0 overruns:0 frame:0
          TX packets:8258 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:591232 (591.2 KB)  TX bytes:591232 (591.2 KB)

mon.wlan0 Link encap:UNSPEC  HWaddr E0-91-53-6F-55-E7-30-30-00-00-00-00-00-00-00-00  
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

wlan0     Link encap:Ethernet  HWaddr e0:91:53:6f:55:e7  
          inet6 addr: fe80::e291:53ff:fe6f:55e7/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1169 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:163223 (163.2 KB)

iwconfig 
lo        no wireless extensions.

br0       no wireless extensions.

wlan0     IEEE 802.11bgn  Mode:Master  Frequency:2.437 GHz  Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
          Power Management:on
          
eth0      no wireless extensions.

mon.wlan0  IEEE 802.11bgn  Mode:Monitor  Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
          Power Management:on
          
nm-tool 
NetworkManager Tool

State: connected (global)

- Device: wlan0 ----------------------------------------------------------------

  Type:              802.11 WiFi
  Driver:            rtl8192ce
  State:             unmanaged
  Default:           no
  HW Address:        E0:91:53:6F:55:E7

  Capabilities:
  Wireless Properties

    WEP Encryption:  yes
    WPA Encryption:  yes
    WPA2 Encryption: yes

  Wireless Access Points 

- Device: eth0 -----------------------------------------------------------------
  Type:              Wired
  Driver:            jme
  State:             unmanaged
  Default:           no
  HW Address:        80:EE:73:31:54:B2

  Capabilities:
    Carrier Detect:  yes
    Speed:           1000 Mb/s

  Wired Properties
    Carrier:         on

is this unmanaged value for the wlan0 normal?

merci
