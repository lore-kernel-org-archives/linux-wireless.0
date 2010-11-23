Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34283 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab0KWNkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 08:40:51 -0500
Received: by iwn33 with SMTP id 33so120603iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 05:40:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CEBBA11.6060505@openwrt.org>
References: <1290475383-26911-1-git-send-email-lrodriguez@atheros.com>
	<1290475383-26911-2-git-send-email-lrodriguez@atheros.com>
	<AANLkTi=LBVHDZSygYA9rF6zWS1JEM3WtP9rA7zpfjNP=@mail.gmail.com>
	<4CEBBA11.6060505@openwrt.org>
Date: Tue, 23 Nov 2010 14:40:49 +0100
Message-ID: <AANLkTi=LyDy6xMYz8z09e9aQpwBu_CVwG1zUjFg2q+Qa@mail.gmail.com>
Subject: Re: [PATCH 2/3] ath9k: avoid aggregation for VO traffic
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Matt Smith <matt.smith@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/23 Felix Fietkau <nbd@openwrt.org>:
> On 2010-11-23 1:14 PM, Björn Smedman wrote:
>> On Tue, Nov 23, 2010 at 2:23 AM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>>> This should help with latency issues which can happen when
>>> using aggregation.
>>
>> Wouldn't it be better to fix the TXOP limit handling in
>> ath_lookup_rate() instead?
> That wouldn't help with latency caused by receiver-side reordering.

Aha, good reason. :)

/Björn
