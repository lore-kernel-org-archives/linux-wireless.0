Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:56723 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3CTIKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 04:10:15 -0400
Received: by mail-oa0-f50.google.com with SMTP id g12so47029oah.9
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 01:10:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130214155840.GA3232@shaftnet.org>
References: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
	<1360355765.29851.29.camel@jlt4.sipsolutions.net>
	<20130214155840.GA3232@shaftnet.org>
Date: Wed, 20 Mar 2013 09:10:14 +0100
Message-ID: <CAM8CFPibkQRrKtekdduZ_eA7rRoqbFp6UR6vr0a8QkgkXi4RxA@mail.gmail.com> (sfid-20130320_091022_641377_B403E7B9)
Subject: Re: RFCv4: ST-E CW1100/1200 WLAN driver
From: Bartosz Markowski <markowski.bartosz@gmail.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/2/14 Solomon Peachy <pizza@shaftnet.org>:
> On Fri, Feb 08, 2013 at 09:36:05PM +0100, Johannes Berg wrote:
>> > There are still a couple bits of code present for older (<2.6.36 and <3.2)
>> > kernels, which I will strip out for inclusion in compat-drivers once
>> > this is mainlined.  (Is there a better process I should follow here?)
>>
>> You should probably just submit it without those bits for the
>> wireless-next tree and then to the relevant compat-drivers patches as
>> needed.
>
> I'm now working on silencing checkpatch's complaints (about 3/4 done
> now); most of them revolve around the use of CamelCase variable names
> all over the place.  In the process I'm doing other low-risk
> opportunistic cleanups.
>
> Once I'm done with that, I'll prepare another submission without the
> backwards compability bits, rebased against wireless-next.
>
>  - Solomon
> --

Hi Salomon,

Is the upstream process dropped or you plan to continue in the near future?

-Bartosz
