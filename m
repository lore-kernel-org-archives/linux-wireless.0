Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51805 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab1C0MgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Mar 2011 08:36:17 -0400
Message-ID: <4D8F2F3E.9030802@openwrt.org>
Date: Sun, 27 Mar 2011 14:36:14 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Klaus_M=FCller?= <kmueller@justmail.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: broken ath9k-driver - problems with creating new TCP-connections.
 Bad performance
References: <4D8F28C1.4060402@justmail.de>
In-Reply-To: <4D8F28C1.4060402@justmail.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-03-27 2:08 PM, Klaus Müller wrote:
> Hello,
>
> I'm running kernel 2.6.38.1 (from the OpenSuSE buildservice on OpenSuSE
> 11.4) and compat-wireless-2011-03-26 (the performance / functionality of
> the driver delivered with 2.6.38.1 is unusable).
> [...]
> iwconfig wlan0
>
> wlan0     IEEE 802.11bgn  ESSID:"ssid"
>            Mode:Managed  Frequency:2.412 GHz  Access Point:
> 00:25:33:22:11:00
>            Bit Rate=150 Mb/s   Tx-Power=17 dBm
>            Retry  long limit:7   RTS thr:off   Fragment thr:off
>            Encryption key:off
>            Power Management:on
>            Link Quality=14/70  Signal level=-63 dBm
>            Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>            Tx excessive retries:4  Invalid misc:1423   Missed beacon:0
>
>
> I run iwconfig 3 times in 7 seconds. The link quality alternated between
> 47 and 14.
>
Have you tried switching your AP to HT20 instead of HT40 to see if that 
improves stability?

- Felix
