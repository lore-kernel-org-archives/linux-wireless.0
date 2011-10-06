Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:41702 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756927Ab1JFVIr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 17:08:47 -0400
Message-ID: <4E8E18DB.5070002@neratec.com> (sfid-20111006_230850_607890_87679435)
Date: Thu, 06 Oct 2011 23:08:43 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	kgiori@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [RFC 5/6] ath9k: enable DFS pulse detection
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com> <201110041538.12885.chunkeey@googlemail.com> <CAB=NE6VC3txpDh4SdDKDxKWKKZVtGQXKVH8opszKDnZeeZTjUQ@mail.gmail.com> <201110061849.48838.chunkeey@googlemail.com> <CAB=NE6WbMi2GYJyFfvsdH-NSXn8dPBsgxgfdGXO_RHiJxwz2Fw@mail.gmail.com> <4E8E1062.1070206@neratec.com> <CAB=NE6XwNDc8v-qtQuQQZdh2ST-skpcZM7wqD32qHn3CgN-5Dw@mail.gmail.com>
In-Reply-To: <CAB=NE6XwNDc8v-qtQuQQZdh2ST-skpcZM7wqD32qHn3CgN-5Dw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06.10.2011 22:41, Luis R. Rodriguez wrote:
> On Thu, Oct 6, 2011 at 1:32 PM, Zefir Kurtisi<zefir.kurtisi@neratec.com>  wrote:
>> As said above, disabling a driver's capability through a Kconfig option
>> should be enough (one ifdef per driver).
>
> OK cool.
>
>> Since regulatory compliance and open source by principle form a
>> gray-zone combination [2], testing for sure is essential to keep it more
>> white than black ;)
>>
>> [2] http://linuxwireless.org/en/developers/Regulatory/statement#Principles
>
> I actually do not think its grey now at all, we in fact IMHO have the
> best regulatory framework out there, while still ensuring freedoms.
>
>    Luis

Sorry, of course it is, I was not specific enough.

I was just wondering if principle 3 generally would prevent us from 
adding a Kconfig option to enable DFS for ath9k as long as it is not 
certified (which is the only way to ensure to have a 'known compliant 
usage') plus depending on mac80211 and hostapd.


Zefir
