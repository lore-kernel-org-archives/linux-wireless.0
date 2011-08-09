Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:58339 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1HIJLU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:11:20 -0400
Received: by pzk37 with SMTP id 37so9785591pzk.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:11:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E40D58A.4000901@01019freenet.de>
References: <CAH-LUqry4TKAvnojAo39QfT-Wy_BN94SYJEiCCRX4hrb=RcfwQ@mail.gmail.com>
	<4E40D58A.4000901@01019freenet.de>
Date: Tue, 9 Aug 2011 17:11:19 +0800
Message-ID: <CAH-LUqojjVCqbg_rQYNCU6Ge2D2ekNWoq03MDKKidqwrNqod0g@mail.gmail.com> (sfid-20110809_111128_598097_3AB0CF20)
Subject: Re: AR9285 Wireless 80211n mode get only 25Mbit with Linux 2.6.38.8
 and compat-wireless-2.6.38.2-2
From: Dane Shih <daneshih1981@gmail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

thanks
kernel upgrade to 3.0
and install compat-wireless_3.0_stable_releases ath9k  driver

[  4] local 192.168.100.254 port 5001 connected with 192.168.100.47 port 49230
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0- 2.1 sec  10.0 MBytes  40.5 Mbits/sec
[  5] local 192.168.100.254 port 5001 connected with 192.168.100.47 port 49231
[  5]  0.0- 6.4 sec  30.0 MBytes  39.2 Mbits/sec

80211n  maxinum throughput 40Mbit

what i should be check

another question
wireless client also get  100 MBit/s

thanks




2011/8/9 Andreas Hartmann <andihartmann@01019freenet.de>:
> Dane Shih schrieb:
>> hi all
>>
>> i try to setup AR9285 Wireless  ap mode on fedora 12
>>
>> but it seem not stable when setup Master mode use hostapd
>> so ...i upgrade kernel to  2.6.38.8
>> it's better, no more disconnect
>>
>> but ap mode in 80211n
>>
>> hostapd.conf
>>
>> nterface=wlan0
>> driver=nl80211
>> ssid=test
>> hw_mode=g
>> wme_enabled=1
>> ieee80211n=1
>> ht_capab=HT40+
>
> I'm using
>
> ht_capab=[HT40+][SHORT-GI-40][DSSS_CCK-40][TX-STBC][RX-STBC1][MAX-AMSDU-3839]
> channel=1
>
> with this chip and get about 100 MBit/s (kernel 3.0 or 2.6.39)
>
>
> Andreas
>
