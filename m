Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50459 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbZG2UBC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 16:01:02 -0400
Message-ID: <4A709E55.2070909@candelatech.com>
Date: Wed, 29 Jul 2009 12:09:09 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian von Bidder <avbidder@fortytwo.ch>
CC: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath5k connection loss (failed to wakeup the MAC Chip)
References: <200907280838.42541@fortytwo.ch> <40f31dec0907281653g63375736id57f547a8ba12cad@mail.gmail.com> <200907291211.21133@fortytwo.ch>
In-Reply-To: <200907291211.21133@fortytwo.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not sure if it helps, but if I:

load ath5k and let some stations associate (I'm testing virtual
STA logic)

.. wait a bit ...

rmmod ath5k; modprobe ath5k

then it fails to wakeup the MAC chip every time.

But, if I then wait a few seconds, and repeat the rmmod/modprobe commands, then it wakes
up and works fine.

I'm running a hacked kernel (and ath5k/wifi stack), so could be something
I'm doing wrong, but just maybe it will give you a reproducible test
case...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

