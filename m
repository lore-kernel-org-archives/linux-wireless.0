Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:32964 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab1C0Op0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Mar 2011 10:45:26 -0400
Received: from [195.4.92.14] (helo=4.mx.freenet.de)
	by mout4.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #3)
	id 1Q3r4c-00051Y-19
	for linux-wireless@vger.kernel.org; Sun, 27 Mar 2011 16:36:10 +0200
Received: from p54a1939c.dip0.t-ipconnect.de ([84.161.147.156]:36458 helo=mail.maya.org)
	by 4.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1Q3r4b-00051N-Ka
	for linux-wireless@vger.kernel.org; Sun, 27 Mar 2011 16:36:09 +0200
Message-ID: <4D8F4B9F.9010809@justmail.de>
Date: Sun, 27 Mar 2011 16:37:19 +0200
From: =?ISO-8859-1?Q?Klaus_M=FCller?= <kmueller@justmail.de>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: broken ath9k-driver - problems with creating new TCP-connections.
 Bad performance
References: <4D8F28C1.4060402@justmail.de> <4D8F2F3E.9030802@openwrt.org>
In-Reply-To: <4D8F2F3E.9030802@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> On 2011-03-27 2:08 PM, Klaus Müller wrote:
>> Hello,
>>
>> I'm running kernel 2.6.38.1 (from the OpenSuSE buildservice on OpenSuSE
>> 11.4) and compat-wireless-2011-03-26 (the performance / functionality of
>> the driver delivered with 2.6.38.1 is unusable).
>> [...]
>> iwconfig wlan0
>>
>> wlan0     IEEE 802.11bgn  ESSID:"ssid"
>>            Mode:Managed  Frequency:2.412 GHz  Access Point:
>> 00:25:33:22:11:00
>>            Bit Rate=150 Mb/s   Tx-Power=17 dBm
>>            Retry  long limit:7   RTS thr:off   Fragment thr:off
>>            Encryption key:off
>>            Power Management:on
>>            Link Quality=14/70  Signal level=-63 dBm
>>            Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>            Tx excessive retries:4  Invalid misc:1423   Missed beacon:0
>>
>>
>> I run iwconfig 3 times in 7 seconds. The link quality alternated between
>> 47 and 14.
>>
> Have you tried switching your AP to HT20 instead of HT40 to see if that
> improves stability?

If the AP is set to HT20, this driver doesn't use IEEE 802.11n any more,
or, to say it more specific: the selected bit rate is max. 64 Mb/s and
the performance is even worse.

I'm wondering at all, why the ath9k driver doesn't switch to 300 Mb/s:
the rt3572sta-driver doesn't have any problem with both settings.


Klaus.
