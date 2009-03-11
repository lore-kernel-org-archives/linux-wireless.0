Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:64968 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZCKVv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 17:51:27 -0400
Received: by fxm24 with SMTP id 24so174413fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2009 14:51:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0903101458k1aaf9455x80a0288daf46a4e3@mail.gmail.com>
References: <4dd58f490903041329p54ec56ceh1b64ab000027eac5@mail.gmail.com>
	 <4dd58f490903041333y4e2abe8r72204232ec4a65ac@mail.gmail.com>
	 <20090304232625.cc47eb46.cjsthompson@gmail.com>
	 <4dd58f490903041451x5044b464k47d70b1210b12f11@mail.gmail.com>
	 <20090304232527.058017da.cjsthompson@gmail.com>
	 <4dd58f490903051449h3b2eb96ay5d83d7ea8129370f@mail.gmail.com>
	 <20090306084527.5a3b6300.cjsthompson@gmail.com>
	 <4dd58f490903101404m3678728ag13735851e232a8f4@mail.gmail.com>
	 <20090310223757.a8618b61.cjsthompson@gmail.com>
	 <b6c5339f0903101458k1aaf9455x80a0288daf46a4e3@mail.gmail.com>
Date: Wed, 11 Mar 2009 21:51:23 +0000
Message-ID: <4dd58f490903111451u4107936du6466d134f0c119d3@mail.gmail.com> (sfid-20090311_225131_160792_2091E74D)
Subject: Re: ath5k master (AP) mode
From: Alexey Yudichev <ayudichev@yahoo.co.uk>
To: Bob Copeland <me@bobcopeland.com>
Cc: "Christoph .J Thompson" <cjsthompson@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, Mar 10, 2009 at 5:37 PM, Christoph .J Thompson
> <cjsthompson@gmail.com> wrote:
>> On Tue, 10 Mar 2009 21:04:17 +0000
>> Alexey Yudichev <ayudichev@yahoo.co.uk> wrote:
>>> Do you know, if I got this far, can unstable connection and not
>>> working WPA be related to older kernel?
>>
>> I can't be sure. I don't have the unstable connection problem but I didn't
>> use WPA yet. So maybe the unstable connection problem only happens with WPA.
>
> It's possible ath5k has bugs in the crypto for AP mode like the ones fixed
> in ath9k recently - you can always try the nohwcrypt=1 modparam.
>
> --
> Bob Copeland %% www.bobcopeland.com
>
nohwcrypt=1 did not help (was I correct to put it as "options ath5k
nohwcrypt=1" into /etc/modprobe.d/options in my ubuntu?).

The problem is not that WPA does not work. It works for my WM6 client
(who connects with or without WPA from some 2nd or 3rd attempt but
cannot browse anything anyway even without encryption) but does not
work for WM5 client (who can browse but only when it connects and it
only connects with WPA disabled). Not sure which component to blame
here. Both devices work so nicely with WPA with hardware wireless
router :)

I guess I'll just wait for future versions of driver and kernel and
keep upgrading hoping that it'll start working.
