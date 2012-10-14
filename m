Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45208 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab2JNNfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2012 09:35:11 -0400
Message-ID: <507ABE4B.6000805@ti.com> (sfid-20121014_153519_105800_DDD78111)
Date: Sun, 14 Oct 2012 15:29:47 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <coelho@ti.com>,
	<assaf@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH v3 5/7] nl80211/cfg80211: add ap channel switch command
References: <1344426823-1795-1-git-send-email-victorg@ti.com>  <1344426823-1795-6-git-send-email-victorg@ti.com>  <1347276227.4272.17.camel@jlt4.sipsolutions.net>  <CAK80WHarUE=6tne+BD=cvMHVT7Yyq+kK2ce=cHvfuapxqyo35w@mail.gmail.com> <1349808259.4683.17.camel@jlt4.sipsolutions.net>
In-Reply-To: <1349808259.4683.17.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/09/2012 08:44 PM, Johannes Berg wrote:
>>>> + * @block_tx: Indicates whether transmission must be blocked before the
>>>> + *   scheduled channel switch, as indicated by the AP.
>
>>> Bogus documentation.
>>
>> can you please elaborate on this one.
>
> for example the only thing I quoted above now ... clearly can't be right
>
>> note that it's almost identical to "ieee80211_channel_switch" struct,
>
> and that's the problem

now I see ;)
will fix the documentation in next v4 series.


-- 
Thanks,
Victor.
