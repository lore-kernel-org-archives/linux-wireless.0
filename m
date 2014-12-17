Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:36248 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaLQUim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 15:38:42 -0500
Message-ID: <5491E9CF.7070300@broadcom.com> (sfid-20141217_213845_578365_93849B19)
Date: Wed, 17 Dec 2014 21:38:39 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Gautam (Gautam Kumar) Shukla" <gautams@broadcom.com>
Subject: Re: nl80211 feature flags
References: <5491E256.40302@broadcom.com> <1418847703.2135.28.camel@sipsolutions.net>
In-Reply-To: <1418847703.2135.28.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/17/14 21:21, Johannes Berg wrote:
> On Wed, 2014-12-17 at 21:06 +0100, Arend van Spriel wrote:
>
>> I intended to add a feature flag, but it seems filled up completely on
>> mac80211-next tree. Did you already have an idea how to extend this?
>
> Yeah, I noticed that before, but I didn't have a plan yet.
>
> I think since the features are documented as a u32 attribute we can't
> extend them very well. I think we probably have to add another attribute
> - but maybe we should define the new one as a u8 array or so to begin
> with (like e.g. the extended capabilities information element)

Agreed. I was thinking in that direction as well. I will include it in 
the series we are preparing for 4-way handshake offload.

Gr. AvS

> johannes
>

