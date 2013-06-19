Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:64978 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845Ab3FSSgp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 14:36:45 -0400
Received: from mailout-de.gmx.net ([10.1.76.1]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0Lds7x-1UP4u03mGR-00j0qR for
 <linux-wireless@vger.kernel.org>; Wed, 19 Jun 2013 20:36:43 +0200
Message-ID: <51C1FA33.2050308@rempel-privat.de> (sfid-20130619_203648_036997_823207CB)
Date: Wed, 19 Jun 2013 20:36:35 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Corey Richardson <corey@octayn.net>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Ignacy Gawedzki <i@lri.fr>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k_htc: station unable to authenticate
References: <20130619115809.GA26717@zenon.in.qult.net> <51C1ACEC.2020703@rempel-privat.de> <1DC40B07CD6EC041A66726C271A73AE61AA312F5@IRSMSX102.ger.corp.intel.com> <51C1B467.1030509@rempel-privat.de> <20130619140905.GA14079@zenon.in.qult.net> <1371651073.8349.19.camel@jlt4.sipsolutions.net> <51C1C95C.8030301@rempel-privat.de> <CA++BO6Rsys5Q_Wxuhcm+00uMvJq3HF2GcU7LmuVsYWq_BW-svw@mail.gmail.com>
In-Reply-To: <CA++BO6Rsys5Q_Wxuhcm+00uMvJq3HF2GcU7LmuVsYWq_BW-svw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 19.06.2013 17:11, schrieb Corey Richardson:
> On Wed, Jun 19, 2013 at 11:08 AM, Oleksij Rempel <linux@rempel-privat.de> wrote:
>> Am 19.06.2013 16:11, schrieb Johannes Berg:
>>>
>>> Btw, I'm a bit confused -- are you using ath9k_htc as per the subject,
>>> or ath9k?
>>>
>>> if it's ath9k_htc then I don't really understand why the patch that
>>> *fixed* it for Corey *broke* it for you?
>>>
>>> johannes
>>
>>
>> It will be interesting to get some more info from Corey, about his wireless
>> setup.
>>
>
> It seems many of my issues were related to a faulty WAP, once I
> replaced it with a different one 90% of my problems went away. What
> information do you want?

Every thing about your old WAP and symptoms of problems you had.
- hardware. also you ath9k_htc adapter too
- firmware
- configuration
- "iw dev wlan0 scan dump"

Currently we have diffetrent mystical bugs, which are impossible to 
reproduce some where else. So we will just collect every information we 
can find.

-- 
Regards,
Oleksij
