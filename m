Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm1.bullet.mail.ird.yahoo.com ([77.238.189.58]:43194 "HELO
	nm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752158Ab2G0KcO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 06:32:14 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EE086.6000304@lwfinger.net> <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com> <501121B5.4010305@lwfinger.net> <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com> <501129D9.4060407@lwfinger.net> <1343314190.31952.YahooMailNeo@web28901.mail.ir2.yahoo.com> <5011BC0A.8060600@lwfinger.net> <1343376844.6746.YahooMailNeo@web28904.mail.ir2.yahoo.com>
Message-ID: <1343385132.37480.YahooMailNeo@web28903.mail.ir2.yahoo.com> (sfid-20120727_123217_833802_8213001F)
Date: Fri, 27 Jul 2012 11:32:12 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1343376844.6746.YahooMailNeo@web28904.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hum the issue is now different as I don't have anymore the wlan0 interface:

iwconfig 
br0       no wireless extensions.

lo        no wireless extensions.

eth0      no wireless extensions.


xabix@HTPC:/var/log$ sudo modprobe rtl8192ce
WARNING: Error inserting rtl8192c_common (/lib/modules/3.4.6-custom/kernel/drivers/net/wireless/rtlwifi/rtl8192c/rtl8192c-common.ko): Invalid argument
FATAL: Error inserting rtl8192ce (/lib/modules/3.4.6-custom/kernel/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192ce.ko): Invalid argument

xabix@HTPC:/var/log$ ll /lib/modules/3.4.6-custom/kernel/drivers/net/wireless/rtlwifi/rtl8192c/rtl8192c-common.ko
-rw-r--r-- 1 root root 71208 Jul 26 12:28 /lib/modules/3.4.6-custom/kernel/drivers/net/wireless/rtlwifi/rtl8192c/rtl8192c-common.ko

modinfo rtl8192ce
filename:       /lib/modules/3.4.6-custom/kernel/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192ce.ko
firmware:       rtlwifi/rtl8192cfwU_B.bin
firmware:       rtlwifi/rtl8192cfwU.bin
firmware:       rtlwifi/rtl8192cfw.bin
description:    Realtek 8192C/8188C 802.11n PCI wireless
license:        GPL
author:         Larry Finger    <Larry.Finger@lwfinger.net>
author:         Realtek WlanFAE <wlanfae@realtek.com>
author:         lizhaoming      <chaoming_li@realsil.com.cn>
srcversion:     AE758D5E662358264A4DB35
alias:          pci:v000010ECd00008176sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008177sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008178sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008191sv*sd*bc*sc*i*
depends:        rtlwifi,rtl8192c-common,mac80211
intree:         Y
vermagic:       3.4.6-custom SMP mod_unload modversions 686 
parm:           swenc:Set to 1 for software crypto (default 0)
parm:           ips:Set to 0 to not use link power save (default 1)

parm:           swlps:Set to 1 to use SW control power save (default 0)

parm:           fwlps:Set to 1 to use FW control power save (default 1)

parm:           debug:Set debug level (0-5) (default 0) (int)


Merci
XabiX
