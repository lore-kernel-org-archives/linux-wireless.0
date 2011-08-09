Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout7.freenet.de ([195.4.92.97]:40839 "EHLO mout7.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab1HIGmV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 02:42:21 -0400
Message-ID: <4E40D58A.4000901@01019freenet.de> (sfid-20110809_084224_924480_09B8EBFD)
Date: Tue, 09 Aug 2011 08:36:58 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Dane Shih <daneshih1981@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: AR9285 Wireless 80211n mode get only 25Mbit with Linux 2.6.38.8
 and compat-wireless-2.6.38.2-2
References: <CAH-LUqry4TKAvnojAo39QfT-Wy_BN94SYJEiCCRX4hrb=RcfwQ@mail.gmail.com>
In-Reply-To: <CAH-LUqry4TKAvnojAo39QfT-Wy_BN94SYJEiCCRX4hrb=RcfwQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dane Shih schrieb:
> hi all
> 
> i try to setup AR9285 Wireless  ap mode on fedora 12
> 
> but it seem not stable when setup Master mode use hostapd
> so ...i upgrade kernel to  2.6.38.8
> it's better, no more disconnect
> 
> but ap mode in 80211n
> 
> hostapd.conf
> 
> nterface=wlan0
> driver=nl80211
> ssid=test
> hw_mode=g
> wme_enabled=1
> ieee80211n=1
> ht_capab=HT40+

I'm using

ht_capab=[HT40+][SHORT-GI-40][DSSS_CCK-40][TX-STBC][RX-STBC1][MAX-AMSDU-3839]
channel=1

with this chip and get about 100 MBit/s (kernel 3.0 or 2.6.39)


Andreas
