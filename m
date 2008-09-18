Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:53469 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254AbYIRXMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 19:12:22 -0400
Received: by gxk9 with SMTP id 9so110706gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 16:12:21 -0700 (PDT)
Message-ID: <43e72e890809181612s1b5016ebsf2b145def401b9cd@mail.gmail.com> (sfid-20080919_011242_870968_FC8A7D64)
Date: Thu, 18 Sep 2008 16:12:21 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: "Ingo Molnar" <mingo@elte.hu>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <f488382f0809181608y3e9fc530k3e770488985e9fe9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
	 <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
	 <43e72e890809181142n7738cd99g522e6688e68d11ce@mail.gmail.com>
	 <f488382f0809181200u9aa03fcv4fc70bd1be7acc71@mail.gmail.com>
	 <43e72e890809181344q416b5944w3332ee5a33db048c@mail.gmail.com>
	 <f488382f0809181449x7343aa7endff066cb5836a73c@mail.gmail.com>
	 <20080918220102.GE7408@tesla>
	 <f488382f0809181608y3e9fc530k3e770488985e9fe9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 18, 2008 at 4:08 PM, Steven Noonan
> Will do! And actually, to be precise, the issue occurred not on the
> rmmod, but on the following modprobe for ath9k.

Ah -- it makes it even more interesting now..

>>> Which is far more important, I agree. It's annoying to get speeds
>>> <802.11b on my pre-802.11n capable chipset and network. ;)
>>
>> Yeah exactly, I hope the work we do will get in for 27. We'll see.
>
> Linus has been fairly strict lately, so I am as uncertain as you are.
> It really should get merged, because having 2.6.27 with [partially]
> broken wireless networking is kind of stupid. In the worst case, isn't
> it possible to do a revert to get the old aggregation crap back in?

Well let us finish the patch first in a way that we are happy with it
:) But yeah if its not merged distributions will probably just pick it
up anyway.

  Luis
