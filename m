Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51982 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1ITVjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 17:39:47 -0400
Received: by fxe4 with SMTP id 4so919746fxe.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 14:39:45 -0700 (PDT)
Message-ID: <4E7907D3.1020606@googlemail.com> (sfid-20110920_233950_475055_897B2CFF)
Date: Tue, 20 Sep 2011 23:38:27 +0200
From: Chiefdome <chiefdome@googlemail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, george0505@realtek.com
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com>
In-Reply-To: <4E785DB3.5040109@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2011 11:32 AM, Chiefdome wrote:
> On 09/20/2011 05:05 AM, Larry Finger wrote:
>> On 09/19/2011 09:27 PM, Chiefdome wrote:
>>> On 09/20/2011 04:10 AM, Chiefdome wrote:
>>>> Hi there,
>>>>
>>>> i just bought an Alfa AWUS036NHR for testing.
>>>> It runs with the rtl8192cu driver.
>>>> I have a question because sometimes the wireless adapter dont shows 
>>>> any
>>>> networks no longer.
>>>> I have to reload the module an then its showing some networks.
>>>>
>>>> In dmesg it shows:
>>>>
>>>> [ 262.219575] ADDRCONF(NETDEV_UP): wlan1: link is not ready
>>>> [ 269.770133] ADDRCONF(NETDEV_UP): wlan1: link is not ready
>>>> [ 270.947047] ADDRCONF(NETDEV_UP): wlan1: link is not ready
>>>>
>>>>
>>>> For any further output please let me know.
>>> A complete dmesg output can be seen here, because theres also a 
>>> problem when
>>> associating to a network:
>>>
>>> [ 1455.353142] cfg80211: All devices are disconnected, going to restore
>>> regulatory settings
>>> [ 1455.353155] cfg80211: Restoring regulatory settings
>>> [ 1455.353165] cfg80211: Calling CRDA to update world regulatory domain
>>> [ 1455.361425] cfg80211: Ignoring regulatory request Set by core 
>>> since the
>>> driver uses its own custom regulatory domain
>>> [ 1455.361436] cfg80211: Ignoring regulatory request Set by core 
>>> since the
>>> driver uses its own custom regulatory domain
>>> [ 1455.361442] cfg80211: World regulatory domain updated:
>>> [ 1455.361447] cfg80211: (start_freq - end_freq @ bandwidth), 
>>> (max_antenna_gain,
>>> max_eirp)
>>> [ 1455.361454] cfg80211: (2400000 KHz - 2494000 KHz @ 40000 KHz), 
>>> (N/A, 3301 mBm)
>>> [ 1455.361460] cfg80211: (4910000 KHz - 5895000 KHz @ 40000 KHz), 
>>> (N/A, 3301 mBm)
>>> [ 1455.403456] iwlagn 0000:03:00.0: L1 Disabled; Enabling L0S
>>> [ 1455.403856] iwlagn 0000:03:00.0: Radio type=0x0-0x2-0x0
>>> [ 1455.459585] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>>> [ 1455.950477] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
>>> [ 1456.010220] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
>>> [ 1456.011668] ADDRCONF(NETDEV_UP): eth0: link is not ready
>>> [ 1495.264204] rtl8192cu: MAC auto ON okay!
>>> [ 1495.299099] rtl8192cu: Tx queue select: 0x05
>>> [ 1495.299880] rtl8192c_common: Loading firmware file 
>>> rtlwifi/rtl8192cufw.bin
>>> [ 1495.709590] ADDRCONF(NETDEV_UP): wlan1: link is not ready
>>> [ 1500.741392] usbcore: deregistering interface driver rtl8192cu
>>> [ 1505.097104] rtl8192cu: MAC address: 00:c0:ca:52:cb:4c
>>> [ 1505.097116] rtl8192cu: Board Type 1
>>> [ 1505.102441] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
>>> [ 1505.102454] cfg80211: Updating information on frequency 2412 MHz 
>>> for a 20 MHz
>>> width channel with regulatory rule:
>>> [ 1505.102462] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (N/A mBi, 
>>> 2000 mBm)
>>> [ 1505.102468] cfg80211: Updating information on frequency 2417 MHz 
>>> for a 20 MHz
>>> width channel with regulatory rule:
>>> [ 1505.102475] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (N/A mBi, 
>>> 2000 mBm)
>>> [ 1505.102480] cfg80211: Updating information on frequency 2422 MHz 
>>> for a 20 MHz
>>> width channel with regulatory rule:
>>> [ 1505.102487] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (N/A mBi, 
>>> 2000 mBm)
>>> [ 1505.102493] cfg80211: Updating information on frequency 2427 MHz 
>>> for a 20 MHz
>>> width channel with regulatory rule:
>>> [ 1505.102499] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (N/A mBi, 
>>> 2000 mBm)
>>> [ 1505.102505] cfg80211: Updating information on frequency 2432 MHz 
>>> for a 20 MHz
>>> width channel with regulatory rule:
>>> [ 1505.102511] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (N/A mBi, 
>>> 2000 mBm)
>>> [ 1505.102517] cfg80211: Updating information on frequency 2437 MHz 
>>> for a 20 MHz
>>> width channel with regulatory rule:
>>> [ 1505.102523] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (N/A mBi, 
>>> 2000 mBm)
>>> [ 1505.102529] cfg80211: Updating information on frequency 2442 MHz 
>>> for a 20 MHz
>>> width channel with regulatory rule:
>>> [ 1505.102536] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (N/A mBi, 
>>> 2000 mBm)
>>> [ 1505.102541] cfg80211: Updating information on frequency 2447 MHz 
>>> for a 20 MHz
>>> width channel with regulatory rule:
>>> [ 1505.102548] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (N/A mBi, 
>>> 2000 mBm)
>>> [ 1505.102553] cfg80211: Updating information on frequency 2452 MHz 
>>> for a 20 MHz
>>> width channel with regulatory rule:
>>> [ 1505.102560] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (N/A mBi, 
>>> 2000 mBm)
>>> [ 1505.102565] cfg80211: Updating information on frequency 2457 MHz 
>>> for a 20 MHz
>>> width channel with regulatory rule:
>>> [ 1505.102572] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (N/A mBi, 
>>> 2000 mBm)
>>> [ 1505.102578] cfg80211: Updating information on frequency 2462 MHz 
>>> for a 20 MHz
>>> width channel with regulatory rule:
>>> [ 1505.102584] cfg80211: 2402000 KHz - 2472000 KHz @ KHz), (N/A mBi, 
>>> 2000 mBm)
>>> [ 1505.102590] cfg80211: Disabling freq 2467 MHz as custom regd has 
>>> no rule that
>>> fits a 20 MHz wide channel
>>> [ 1505.102595] cfg80211: Disabling freq 2472 MHz as custom regd has 
>>> no rule that
>>> fits a 20 MHz wide channel
>>> [ 1505.102601] cfg80211: Disabling freq 2484 MHz as custom regd has 
>>> no rule that
>>> fits a 20 MHz wide channel
>>> [ 1505.103549] cfg80211: Ignoring regulatory request Set by core 
>>> since the
>>> driver uses its own custom regulatory domain
>>> [ 1505.103803] ieee80211 phy2: Selected rate control algorithm 'rtl_rc'
>>> [ 1505.105949] usbcore: registered new interface driver rtl8192cu
>>> [ 1513.004969] rtl8192cu: MAC auto ON okay!
>>> [ 1513.038127] rtl8192cu: Tx queue select: 0x05
>>> [ 1513.038878] rtl8192c_common: Loading firmware file 
>>> rtlwifi/rtl8192cufw.bin
>>> [ 1513.443284] ADDRCONF(NETDEV_UP): wlan1: link is not ready
>>> [ 1519.568596] rtl8192cu: MAC auto ON okay!
>>> [ 1519.601476] rtl8192cu: Tx queue select: 0x05
>>> [ 1519.602253] rtl8192c_common: Loading firmware file 
>>> rtlwifi/rtl8192cufw.bin
>>> [ 1520.008221] ADDRCONF(NETDEV_UP): wlan1: link is not ready
>>> [ 1520.350447] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
>>> [ 1520.410244] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
>>> [ 1520.411607] ADDRCONF(NETDEV_UP): eth0: link is not ready
>>> [ 1520.619096] rtl8192cu: MAC auto ON okay!
>>> [ 1520.651975] rtl8192cu: Tx queue select: 0x05
>>> [ 1520.652755] rtl8192c_common: Loading firmware file 
>>> rtlwifi/rtl8192cufw.bin
>>> [ 1521.060567] ADDRCONF(NETDEV_UP): wlan1: link is not ready
>>> [ 1524.272807] wlan1: authenticate with [MAC-ADDRESS] (try 1)
>>> [ 1524.299985] wlan1: authenticated
>>> [ 1524.300029] wlan1: associate with [MAC-ADDRESS] (try 1)
>>> [ 1524.309323] wlan1: RX AssocResp from [MAC-ADDRESS] (capab=0x431 
>>> status=0 aid=1)
>>> [ 1524.309331] wlan1: associated
>>> [ 1524.311767] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
>>> [ 1525.172880] type=1400 audit(1316485102.702:35): apparmor="DENIED"
>>> operation="open" parent=5409 profile="/sbin/dhclient"
>>> name="/var/lib/wicd/dhclient.conf" pid=5445 comm="dhclient" 
>>> requested_mask="r"
>>> denied_mask="r" fsuid=0 ouid=0
>>> [ 1534.590028] wlan1: no IPv6 routers present
>>
>> What kernel? There are some problems with kernels prior to 3.1 in 
>> connecting to 802.11n networks, and also a problem in clearing the 
>> keys. Both of these problems are fixed in the latest compat-wireless.
>>
>> Larry
>>
> Kernel is Linux C1 3.1.0-rc6linux-next1.01-next-20110919 #1 SMP Mon 
> Sep 19 14:23:56 CEST 2011 x86_64 x86_64 x86_64 GNU/Linux
> I tried to apply the latest compat-wireless but errors are the same.
>
> Chiefdome
I tried at least wireless-next but the adapter isn't showing up.
Where to get more log files and stuff?
Isnt this adapter good supported by the rtl8192cu driver or where is the 
problem?

Kind Regards

Chiefdome

