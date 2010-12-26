Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sinikuusama.dnainternet.net ([83.102.40.134]:38141 "EHLO
	sinikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128Ab0LZOxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 09:53:54 -0500
Message-ID: <20101226165345.19416mpbg3hsggg8@hayate.sektori.org>
Date: Sun, 26 Dec 2010 16:53:45 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: =?utf-8?b?UmFmYcWCIA==?= =?utf-8?b?TWnFgmVja2k=?=
	<zajec5@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	zd1211-devs@lists.sourceforge.net,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [RFC PATCH 0/6] zd1211rw: add support for AP mode
References: <20101226112404.31775.77854.stgit@fate.lan>
 <1293366263.3537.1.camel@jlt3.sipsolutions.net>
 <AANLkTim_G3Q8tkNepERTWT-0j118ZxTbN==Z9ufCUWRa@mail.gmail.com>
In-Reply-To: <AANLkTim_G3Q8tkNepERTWT-0j118ZxTbN==Z9ufCUWRa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Rafał Miłecki <zajec5@gmail.com>:

> 2010/12/26 Johannes Berg <johannes@sipsolutions.net>:
>> On Sun, 2010-12-26 at 13:24 +0200, Jussi Kivilinna wrote:
>>
>>>  1. I have not been able to trigger bc/mc buffering. I have tested with
>>>     b43 and rndis_wlan stations.
>>
>> Put the stations into powersave mode. I guess neither of those actually
>> support that, though you might easily pretend to support powersave in
>> b43 -- even if it won't save power it'll have the AP trigger this.
>>
>> However, bc/mc buffering is a very important feature of AP mode, so you
>> shouldn't try to support AP mode w/o it.
>
> What do bc and mc stand for?

Broadcast/multicast.

-Jussi

