Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:45821 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZIYVHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 17:07:04 -0400
Received: by iwn8 with SMTP id 8so1826186iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 14:07:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ABD2ECE.50501@gmail.com>
References: <loom.20090925T193922-290@post.gmane.org> <200909252005.23746.mb@bu3sch.de>
	<loom.20090925T222532-791@post.gmane.org> <4ABD2ECE.50501@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 25 Sep 2009 14:06:48 -0700
Message-ID: <43e72e890909251406o64417544w2fd836f820eae80e@mail.gmail.com>
Subject: Re: Porting AR6K to use cfg80211
To: Dave <kilroyd@googlemail.com>
Cc: Matthew Ryan <rudicus@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 25, 2009 at 1:57 PM, Dave <kilroyd@googlemail.com> wrote:
> Matthew Ryan wrote:
>> Michael Buesch <mb@...> writes:
>>> On Friday 25 September 2009 19:40:52 Matthew Ryan wrote:
>>>> I was curious if I could get a few expert opinions on if its possible to port
>>>> this driver to use mac80211, and how difficult/ what pitfalls there may be.
>>> The device is fullmac, so it does not require mac80211.
>>> I guess however, ar6k can be ported to use cfg80211.
>>>
>>
>> Do you know of any examples in the source tree which are fullmac, but utilize
>> cfg80211 that I could use as a base to get started?
>
> There are a few fullmac drivers in wireless-testing that use cfg80211. I
> don't think these are in the recently released 2.6.31, but are queued
> for 2.6.32.
>
> iwmc3200wifi and rndis_wlan are furthest along. orinoco is in the
> process of conversion (it uses cfg80211, but relies on the wext
> compatibility code for a large portion of functionality).

Additionally you can poke at the HTC / HIF stuff I'm doing for ar9271:

http://wireless.kernel.org/en/users/Drivers/ath9k_htc

Granted I've removed all credit distribution stuff as ar9271 doesn't
use it, but it still may be easier to use that then what I had seen on
ar6k for HTC.

  Luis
