Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59525 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934694Ab3FSS4A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 14:56:00 -0400
Received: from mailout-de.gmx.net ([10.1.76.31]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MCvtd-1UyPxF40Pr-009dKK for
 <linux-wireless@vger.kernel.org>; Wed, 19 Jun 2013 20:55:58 +0200
Message-ID: <51C1FEB4.5040809@rempel-privat.de> (sfid-20130619_205604_907694_EF1611DB)
Date: Wed, 19 Jun 2013 20:55:48 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Ignacy Gawedzki <i@lri.fr>,
	Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Corey Richardson <corey@octayn.net>
Subject: Re: [ath9k-devel] ath9k_htc: station unable to authenticate
References: <20130619115809.GA26717@zenon.in.qult.net> <51C1ACEC.2020703@rempel-privat.de> <1DC40B07CD6EC041A66726C271A73AE61AA312F5@IRSMSX102.ger.corp.intel.com> <51C1B467.1030509@rempel-privat.de> <20130619140905.GA14079@zenon.in.qult.net> <1371651073.8349.19.camel@jlt4.sipsolutions.net> <51C1C95C.8030301@rempel-privat.de> <20130619175939.GA19405@zenon.in.qult.net> <20130619180354.GB19405@zenon.in.qult.net> <51C1FA76.3090109@rempel-privat.de> <51C1FAFB.9090209@candelatech.com>
In-Reply-To: <51C1FAFB.9090209@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 19.06.2013 20:39, schrieb Ben Greear:
> On 06/19/2013 11:37 AM, Oleksij Rempel wrote:
>>
>>
>> Am 19.06.2013 20:03, schrieb Ignacy Gawedzki:
>>> On Wed, Jun 19, 2013 at 07:59:39PM +0200, thus spake Ignacy Gawedzki:
>>>> On Wed, Jun 19, 2013 at 05:08:12PM +0200, thus spake Oleksij Rempel:
>>>>> Ignacy, Is it RPi +  TL-WN722NC?
>>>>
>>>> Yes, absolutely, but it happens on a Dell XPS 13" as well (Ubuntu
>>>> 13.04).
>>>
>>> BTW, removing CFG80211_DEFAULT_PS doesn't make any difference.
>>
>> Can you please tell more about your access point:
>> - hardware
>> - firmware
>> - configuration
>> - "iw dev wlan0 scan dump"
>
> Does the ath9k_htc do it's own rate control, perhaps modelled on
> ath9k_rate_control
> algorithm?
>
> If so, that could be the problem...it has issues with associating when
> network conditions are poor...

uff... yeah... we can't do comparison test :( except just come closer to AP.

-- 
Regards,
Oleksij
