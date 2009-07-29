Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:40931 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZG2VH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 17:07:29 -0400
Received: by ewy10 with SMTP id 10so297353ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 14:07:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A709E55.2070909@candelatech.com>
References: <200907280838.42541@fortytwo.ch>
	 <40f31dec0907281653g63375736id57f547a8ba12cad@mail.gmail.com>
	 <200907291211.21133@fortytwo.ch> <4A709E55.2070909@candelatech.com>
Date: Thu, 30 Jul 2009 00:07:28 +0300
Message-ID: <40f31dec0907291407p18d2a645u1736ecd4f0258a8a@mail.gmail.com>
Subject: Re: ath5k connection loss (failed to wakeup the MAC Chip)
From: Nick Kossifidis <mickflemm@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Adrian von Bidder <avbidder@fortytwo.ch>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/29 Ben Greear <greearb@candelatech.com>:
> I'm not sure if it helps, but if I:
>
> load ath5k and let some stations associate (I'm testing virtual
> STA logic)
>
> .. wait a bit ...
>
> rmmod ath5k; modprobe ath5k
>
> then it fails to wakeup the MAC chip every time.
>
> But, if I then wait a few seconds, and repeat the rmmod/modprobe commands,
> then it wakes
> up and works fine.
>
> I'm running a hacked kernel (and ath5k/wifi stack), so could be something
> I'm doing wrong, but just maybe it will give you a reproducible test
> case...
>
> Thanks,
> Ben
>

Patch on the way ;-)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
