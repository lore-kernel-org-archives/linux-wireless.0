Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40496 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab1AGWTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 17:19:06 -0500
Received: by iwn9 with SMTP id 9so17622777iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 14:19:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110107221305.6484.qmail@stuge.se>
References: <AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com>
 <AANLkTin8JO4UHUYLufSmPhRw0ZndDdjTpueSOHNQbDiZ@mail.gmail.com>
 <20110107024432.GC20431@tux> <201101071111.17423.helmut.schaa@googlemail.com>
 <AANLkTi=cxggOG6xkVQqJ9S+ieg8LD43TSVEYAJW7YFrk@mail.gmail.com>
 <20110107202224.GI21588@tux> <20110107221305.6484.qmail@stuge.se>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 7 Jan 2011 14:18:45 -0800
Message-ID: <AANLkTikL0ONLAd7qncZtafRpxQh1jBG9_xs5xPjTgAxT@mail.gmail.com>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Aleksandar Milivojevic <alex@milivojevic.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 7, 2011 at 2:13 PM, Peter Stuge <peter@stuge.se> wrote:
> Luis R. Rodriguez wrote:
>>         bgscan="simple:30:-45:300"
> ..
>> No Linux distributions today uses this other than ChromeOS, but
>> they should all change to use it.
>
> Maybe wpa_supplicant should be changed to use it by default?

The supplicant is configured by dbus, so its not up to the supplicant
by design. What has to change is Network Manager and connman needs to
change to use bgscan by default. ChromeOS uses a fork of connman
called flimflam and it uses it by default now.

  Luis
