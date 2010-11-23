Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58319 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931Ab0KWM4w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 07:56:52 -0500
Message-ID: <4CEBBA11.6060505@openwrt.org>
Date: Tue, 23 Nov 2010 13:56:49 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Matt Smith <matt.smith@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: [PATCH 2/3] ath9k: avoid aggregation for VO traffic
References: <1290475383-26911-1-git-send-email-lrodriguez@atheros.com>	<1290475383-26911-2-git-send-email-lrodriguez@atheros.com> <AANLkTi=LBVHDZSygYA9rF6zWS1JEM3WtP9rA7zpfjNP=@mail.gmail.com>
In-Reply-To: <AANLkTi=LBVHDZSygYA9rF6zWS1JEM3WtP9rA7zpfjNP=@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-23 1:14 PM, Björn Smedman wrote:
> On Tue, Nov 23, 2010 at 2:23 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> This should help with latency issues which can happen when
>> using aggregation.
> 
> Wouldn't it be better to fix the TXOP limit handling in
> ath_lookup_rate() instead?
That wouldn't help with latency caused by receiver-side reordering.

- Felix
