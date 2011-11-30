Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44803 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab1K3OQo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 09:16:44 -0500
Received: by eaak14 with SMTP id k14so721707eaa.19
        for <linux-wireless@vger.kernel.org>; Wed, 30 Nov 2011 06:16:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322641938.3982.0.camel@jlt3.sipsolutions.net>
References: <1322533625-24641-1-git-send-email-mar.kolya@gmail.com>
	<1322555084.4110.2.camel@jlt3.sipsolutions.net>
	<CALGY4fvLSKBY93M9Bhb-F8Sm=Uw5nU+OvTtAmk_BXQX8WX6V8A@mail.gmail.com>
	<1322579973.4110.22.camel@jlt3.sipsolutions.net>
	<CALGY4fvSOdKtZbPSdvYkY3XXaGXNo-Ft8ir4LikmnTLqSkVCGA@mail.gmail.com>
	<1322604877.11282.1.camel@jlt3.sipsolutions.net>
	<CALGY4ftCLvwUuRZbH30PyUxAd6U7-p9hGwu8SjzLmqV4=XryZg@mail.gmail.com>
	<1322606159.11282.2.camel@jlt3.sipsolutions.net>
	<CALGY4fu7DExMn6BCrwTMCEav1VEe81NAvJapiLXoi_DSf50ctg@mail.gmail.com>
	<1322641938.3982.0.camel@jlt3.sipsolutions.net>
Date: Wed, 30 Nov 2011 09:16:43 -0500
Message-ID: <CALGY4fup7F-581LYfcSZYGvMOqzrNxiNedVbQOOb_VjVwzrokQ@mail.gmail.com> (sfid-20111130_151648_248497_7AF42156)
Subject: Re: [PATCH] mac80211: reset addba retries after timeout
From: Nikolay Martynov <mar.kolya@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/30 Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2011-11-29 at 17:46 -0500, Nikolay Martynov wrote:
>
>> > Maybe the better approach would be to bump it up, but also only allow an
>> > attempt once every say 15 seconds or so? It seems kinda useless to try 3
>> > (or 10/15) times in quick succession and then give up, vs. just trying
>> > more spaced out?
>>
>>   Makes sense to me. Although I would left first 2-3 go quickly in
>> case first was lost due to random glitch there is no reason to wait 15
>> seconds. But if first 2-3 fail - it make sense split next apart, I
>> think.
>
> Seems ok to me, want to implement it? :)

  Sure, I'll send patch for this.



-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
