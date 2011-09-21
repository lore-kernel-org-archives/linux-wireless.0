Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:52705 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1IUUDc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 16:03:32 -0400
Received: by yib18 with SMTP id 18so1393928yib.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 13:03:31 -0700 (PDT)
Message-ID: <4E7A4310.30106@lwfinger.net> (sfid-20110921_220335_515324_4DAFD7E3)
Date: Wed, 21 Sep 2011 15:03:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chiefdome <chiefdome@googlemail.com>
CC: george0505@realtek.com, linux-wireless@vger.kernel.org
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com> <4E7907D3.1020606@googlemail.com> <4E792994.1080809@lwfinger.net> <4E79B1D0.7090602@googlemail.com> <4E79F87F.1050402@lwfinger.net> <4E7A38D0.7070304@googlemail.com>
In-Reply-To: <4E7A38D0.7070304@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2011 02:19 PM, Chiefdome wrote:
> I have found another bug - it is impossible to me to connect a WPA2-network -
> here is the dmesg output for that - will send you the output for a WEP-network
> later then:
>
> [ 194.011573] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [ 194.230135] rtl8192cu: MAC auto ON okay!
> [ 194.263015] rtl8192cu: Tx queue select: 0x05
> [ 194.263820] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
> [ 194.670927] ADDRCONF(NETDEV_UP): wlan1: link is not ready
> [ 237.379814] rtl8192cu: MAC auto ON okay!
> [ 237.413488] rtl8192cu: Tx queue select: 0x05
> [ 237.414243] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
> [ 237.821229] ADDRCONF(NETDEV_UP): wlan1: link is not ready
> [ 238.160462] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
> [ 238.220187] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
> [ 238.221641] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [ 278.340442] usbcore: deregistering interface driver rtl8192cu
> [ 326.145824] rtl8192cu:rtl92cu_read_eeprom_info():<0-0> Boot from EFUSE
> [ 326.223617] rtl8192cu: MAC address: [MAC-ADDRESS]
> [ 326.223629] rtl8192cu:_rtl92cu_read_adapter_info():<0-0> VID = 0xbda PID = 0x817f
> [ 326.223636] rtl8192cu: Board Type 1
> [ 326.223641] rtl8192cu:_rtl92cu_hal_customized_behavior():<0-0> RT Customized
> ID: 0x00
> [ 326.227751] rtlwifi:_rtl_usb_init():<0-0> USB EP(0x81), MaxPacketSize=512
> ,Interval=0.
> [ 326.227762] rtlwifi:_rtl_usb_init():<0-0> USB EP(0x02), MaxPacketSize=512
> ,Interval=0.
> [ 326.227770] rtlwifi:_rtl_usb_init():<0-0> USB EP(0x03), MaxPacketSize=512
> ,Interval=0.
> [ 326.227777] rtlwifi:_rtl_usb_init():<0-0> USB EP(0x84), MaxPacketSize=64
> ,Interval=1.
> [ 326.228202] rtl8192cu:_TwoOutEpMapping():<0-0> USB typical Setting.....
> [ 326.228209] rtlwifi:_rtl_usb_init_tx():<0-0> USB Max Bulk-out Size=512
> [ 326.228217] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
> [ 326.228223] rtlwifi:_rtl_init_hw_ht_capab():<0-0> 1T1R
> [ 326.228234] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz
> width channel with regulatory rule:
> [ 326.228241] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
> [ 326.228247] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz
> width channel with regulatory rule:
> [ 326.228253] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
> [ 326.228259] cfg80211: Updating information on frequency 2422
> MH00:1c:4a:03:b9:64z for a 20 MHz width channel with regulatory rule:
> [ 326.228266] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
> [ 326.228271] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz
> width channel with regulatory rule:
> [ 326.228278] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
> [ 326.228284] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz
> width channel with regulatory rule:
> [ 326.228290] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
> [ 326.228296] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz
> width channel with regulatory rule:
> [ 326.228302] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
> [ 326.228308] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz
> width channel with regulatory rule:
> [ 326.228314] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
> [ 326.228320] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz
> width channel with regulatory rule:
> [ 326.228327] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
> [ 326.228332] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz
> width channel with regulatory rule:
> [ 326.228339] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
> [ 326.228344] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz
> width channel with regulatory rule:
> [ 326.228351] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
> [ 326.228356] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz
> width channel with regulatory rule:
> [ 326.228363] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
> [ 326.228369] cfg80211: Disabling freq 2467 MHz as custom regd has no rule that
> fits a 20 MHz wide channel
> [ 326.228374] cfg80211: Disabling freq 2472 MHz as custom regd has no rule that
> fits a 20 MHz wide channel
> [ 326.228380] cfg80211: Disabling freq 2484 MHz as custom regd has no rule that
> fits a 20 MHz wide channel
> [ 326.228554] cfg80211: Ignoring regulatory request Set by core since the driver
> uses its own custom regulatory domain
> [ 326.228881] ieee80211 phy2: Selected rate control algorithm 'rtl_rc'
> [ 326.234614] usbcore: registered new interface driver rtl8192cu
> [ 330.227015] rtl8192cu:_rtl92cu_init_power_on():<0-0> Autoload Done!
> [ 330.228731] rtl8192cu: MAC auto ON okay!
> [ 330.264497] rtl8192cu: Tx queue select: 0x05
> [ 330.264507] rtl8192cu:rtl92c_set_network_type():<0-0> Set Network type to NO
> LINK!
> [ 330.265249] rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0> FALSE driver sleep
> or unload
> [ 330.265265] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
> [ 330.265269] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(63),
> Signature(0x88c1),Size(32)
> [ 330.658702] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
> [ 330.658734] rtl8192cu:rtl92cu_set_hw_reg():<0-0> Set
> HW_VAR_RETRY_LIMIT(0x00000004)
> [ 330.670568] ADDRCONF(NETDEV_UP): wlan1: link is not ready
> [ 340.000671] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
> [ 340.016768] rtl8192cu:_rtl92cu_init_power_on():<0-0> Autoload Done!
> [ 340.018500] rtl8192cu: MAC auto ON okay!
> [ 340.051808] rtl8192cu: Tx queue select: 0x05
> [ 340.051828] rtl8192cu:rtl92c_set_network_type():<0-0> Set Network type to NO
> LINK!
> [ 340.052543] rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0> FALSE driver sleep
> or unload
> [ 340.052583] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
> [ 340.052590] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(63),
> Signature(0x88c1),Size(32)
> [ 340.450345] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002ace) ###
> [ 340.450367] rtl8192cu:rtl92cu_set_hw_reg():<0-0> Set
> HW_VAR_RETRY_LIMIT(0x00000004)
> [ 340.462324] ADDRCONF(NETDEV_UP): wlan1: link is not ready
> [ 340.810935] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
> [ 340.870239] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
> [ 340.871685] ADDRCONF(NETDEV_UP): eth0: link is not ready
> [ 340.960624] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
> [ 341.088320] rtl8192cu:_rtl92cu_init_power_on():<0-0> Autoload Done!
> [ 341.091812] rtl8192cu: MAC auto ON okay!
> [ 341.128338] rtl8192cu: Tx queue select: 0x05
> [ 341.128356] rtl8192cu:rtl92c_set_network_type():<0-0> Set Network type to NO
> LINK!
> [ 341.129072] rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0> FALSE driver sleep
> or unload
> [ 341.129112] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
> [ 341.129119] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(63),
> Signature(0x88c1),Size(32)
> [ 341.523259] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002ace) ###
> [ 341.523296] rtl8192cu:rtl92cu_set_hw_reg():<0-0> Set
> HW_VAR_RETRY_LIMIT(0x00000004)
> [ 341.535132] ADDRCONF(NETDEV_UP): wlan1: link is not ready
> [ 344.553546] wlan1: direct probe to [MAC-ADDRESS] (try 1/3)
> [ 344.750275] wlan1: direct probe to [MAC-ADDRESS] (try 2/3)
> [ 344.950061] wlan1: direct probe to [MAC-ADDRESS] (try 3/3)
> [ 345.150150] wlan1: direct probe to [MAC-ADDRESS] timed out

The first thing I notice is that you apparently do not have CRDA installed. A 
second thing is that the interface never comes up. As long as it remains down, 
it can never connect. How are you connecting? I'm using NetworkManager.

The following is an excerpt from my dmesg log with debug=3 set when rtlwifi is 
loaded:

[17268.232826] usbcore: registered new interface driver rtl8192cu
[17268.352125] rtl8192cu:_rtl92cu_init_power_on():<0-0> Autoload Done!
[17268.364205] rtl8192cu: MAC auto ON okay!
[17269.148482] rtl8192cu: Tx queue select: 0x05
[17269.149472] rtl8192cu:rtl92c_set_network_type():<0-0> Set Network type to NO 
LINK!
[17269.159549] rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0> FALSE driver sleep 
or unload
[17269.161148] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cufw.bin
[17269.161177] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(63), 
Signature(0x88c1),Size(32)
[17270.343392] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
[17270.345208] rtl8192cu:rtl92cu_set_hw_reg():<0-0> Set 
HW_VAR_RETRY_LIMIT(0x00000004)
[17270.388005] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[17274.168628] wlan0: authenticate with c0:3f:0e:be:2b:44 (try 1)
[17274.168756] rtlwifi:_rtl_usb_tx_preprocess():<200-1> MAC80211_LINKING
[17274.173393] wlan0: authenticated
[17274.259600] wlan0: associate with c0:3f:0e:be:2b:44 (try 1)
[17274.267367] wlan0: RX AssocResp from c0:3f:0e:be:2b:44 (capab=0x411 status=0 
aid=1)
[17274.267400] wlan0: associated
[17274.267428] rtlwifi:rtl_op_sta_add():<0-0> Add sta addr is c0:3f:0e:be:2b:44
[17274.267614] rtl8192cu:rtl92cu_update_hal_rate_table():<0-0> 0
[17274.274103] rtlwifi:rtl_action_proc():<10000-1> Rx ACT_ADDBAREQ From 
:c0:3f:0e:be:2b:44
[17274.322888] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ASSOC
[17274.325839] rtlwifi:rtl_op_bss_info_changed():<0-0> c0:3f:0e:be:2b:44
[17274.336522] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002ace) ###
[17274.340812] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[17274.340968] rtlwifi:rtl_action_proc():<200-1> Tx ACT_ADDBARSP From 
:00:1f:1f:c8:8e:cb
[17274.358740] rtlwifi:rtl_op_set_key():<0-0> Using hardware based encryption 
for keyidx: 0, mac: c0:3f:0e:be:2b:44
[17274.358799] rtlwifi:rtl_op_set_key():<0-0> alg:CCMP
[17274.358818] rtlwifi:rtl_op_set_key():<0-0> set enable_hw_sec, 
key_type:4(OPEN:0 WEP40:1 TKIP:2 AES:4 WEP104:5)
[17274.359178] rtlwifi:rtl_op_set_key():<0-0> set pairwise key
[17274.359202] rtl8192cu:rtl92c_set_key():<0-0> add one entry
[17274.359222] rtl8192cu:rtl92c_set_key():<0-0> set Pairwiase key
[17274.359244] rtlwifi:rtl_cam_add_one_entry():<0-0> EntryNo:4, ulKeyId=0, 
ulEncAlg=4, ulUseDK=0 MacAddr c0:3f:0e:be:2b:44
[17274.364992] rtlwifi:rtl_cam_add_one_entry():<0-0> <===
[17274.367387] rtlwifi:rtl_op_set_key():<0-0> Using hardware based encryption 
for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
[17274.367434] rtlwifi:rtl_op_set_key():<0-0> alg:CCMP
[17274.367457] rtlwifi:rtl_op_set_key():<0-0> set group key
[17274.367483] rtl8192cu:rtl92c_set_key():<0-0> add one entry
[17274.367506] rtl8192cu:rtl92c_set_key():<0-0> set group key
[17274.367529] rtlwifi:rtl_cam_add_one_entry():<0-0> EntryNo:1, ulKeyId=1, 
ulEncAlg=4, ulUseDK=0 MacAddr ff:ff:ff:ff:ff:ff
[17274.372787] rtlwifi:rtl_cam_add_one_entry():<0-0> <===
[17274.416690] rtl8192cu:rtl92cu_update_hal_rate_table():<0-0> 15
[17276.428211] rtl8192cu:rtl92cu_update_hal_rate_table():<0-0> 15
[17280.412251] rtl8192cu:rtl92cu_update_hal_rate_table():<0-0> 15
[17293.203904] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set RCR(0xf0002a0e) ###
[17295.692077] rtlwifi:rtl_tx_agg_start():<0-0> on ra = c0:3f:0e:be:2b:44 tid = 
0 seq:0
[17295.692345] rtlwifi:rtl_action_proc():<200-1> Tx ACT_ADDBAREQ From 
:00:1f:1f:c8:8e:cb
[17295.695093] rtlwifi:rtl_action_proc():<10000-1> Rx ACT_ADDBARSP From 
:c0:3f:0e:be:2b:44
[17295.695400] rtlwifi:rtl_tx_agg_oper():<0-0> on ra = c0:3f:0e:be:2b:44 tid = 0

As you notice, this connection uses the CCMP algorithm, i.e. it is with 
WPA2-AES.  It is also an 802.11n. Just to test, I switched the AP to run only at 
802.11g rates. That also worked.

I need to know more about your setup. What AP and how is it configured? How do 
you control the wireless connection?

Larry
