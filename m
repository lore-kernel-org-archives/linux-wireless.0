Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50984 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab3FTGrO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jun 2013 02:47:14 -0400
Received: from mailout-de.gmx.net ([10.1.76.20]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LiFq9-1UT8BW0frv-00nQ5P for
 <linux-wireless@vger.kernel.org>; Thu, 20 Jun 2013 08:47:13 +0200
Message-ID: <51C2A567.2010409@rempel-privat.de> (sfid-20130620_084717_513035_401FA804)
Date: Thu, 20 Jun 2013 08:47:03 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Ignacy Gawedzki <i@lri.fr>,
	Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Corey Richardson <corey@octayn.net>
Subject: Re: [ath9k-devel] ath9k_htc: station unable to authenticate
References: <1DC40B07CD6EC041A66726C271A73AE61AA312F5@IRSMSX102.ger.corp.intel.com> <51C1B467.1030509@rempel-privat.de> <20130619140905.GA14079@zenon.in.qult.net> <1371651073.8349.19.camel@jlt4.sipsolutions.net> <51C1C95C.8030301@rempel-privat.de> <20130619175939.GA19405@zenon.in.qult.net> <20130619180354.GB19405@zenon.in.qult.net> <51C1FA76.3090109@rempel-privat.de> <20130619193316.GA29582@zenon.in.qult.net> <51C2942A.2080706@rempel-privat.de> <20130620063925.GA3885@zenon.in.qult.net>
In-Reply-To: <20130620063925.GA3885@zenon.in.qult.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 20.06.2013 08:39, schrieb Ignacy Gawedzki:
> On Thu, Jun 20, 2013 at 07:33:30AM +0200, thus spake Oleksij Rempel:
>> Am 19.06.2013 21:33, schrieb Ignacy Gawedzki:
>>> I tested the thing with at least three different APs:
>>>
>>>    - Netgear DG834Gv4 with latest firmware.
>>
>> this one is BG with Broadcom BCM4318. Is here original firmware or openwrt?
>
> Original firmware, since OpenWRT doesn't support the ADSL chip.
>
>>>    - Netgear DG834Gv5 (don't know which firmware and can't check at this time).
>>
>> this is BG with Conexant CX94610
>>
>>>    - hostapd (can't say which version at this time either) with the same
>>>      ath9k_htc.
>>
>> this one is actually BGN, did you configured it for N? Can you
>> please provide your hostapd.conf.
>
> I'll manage to get the configuration as soon as possible.  It seems the
> association problem went away since I patched the drivers on the AP too, so
> "unpatching" the drivers on the station is not enough to reproduce the
> problem.  I'll unpatch the drivers on the AP and re-run the test.
>
>> Do you have problems on all 3 configurations?
>
> On both Netgears for sure.  For hostapd I'll confirm that in a little while.
>
>>                                                Can you please test it
>> with some N (HT) capable AP. But please, not with N-draft certified
>> AP.
>
> Is ath9k_htc N-capable?

Yes, if hostapd configured properly.

Question to Corey,

i assume your old AP was supporting only BG networks. And your new one, 
which is working fine, supports N?

-- 
Regards,
Oleksij
