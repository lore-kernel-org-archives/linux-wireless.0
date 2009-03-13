Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:62703 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbZCMTGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 15:06:23 -0400
Received: by fxm24 with SMTP id 24so2759661fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 12:06:20 -0700 (PDT)
Subject: Re: [ath5k-devel] Thanks for TX power patch
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mick@madwifi-project.org>,
	Helmut Schaa <helmut.schaa@googlemail.com>
In-Reply-To: <b6c5339f0903131123h4cb6379k472166ff81b9c5f2@mail.gmail.com>
References: <1236728344.26432.26.camel@maxim-laptop>
	 <d94c510d0903110115s620c7851g391fcf00e644a113@mail.gmail.com>
	 <b6c5339f0903120714rda8ec3ev2c2fbfaaf0b21351@mail.gmail.com>
	 <1236893111.30325.10.camel@maxim-laptop>
	 <b6c5339f0903121432h26d71d6nd901f12d0c10e7bc@mail.gmail.com>
	 <b6c5339f0903121433r7bbf2dd8l484d15446241dccd@mail.gmail.com>
	 <1236895489.17849.3.camel@maxim-laptop>
	 <1236940708.4708.14.camel@maxim-laptop>
	 <b6c5339f0903131123h4cb6379k472166ff81b9c5f2@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 21:06:15 +0200
Message-Id: <1236971175.9102.14.camel@localhost> (sfid-20090313_200626_936840_A3B27051)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-03-13 at 14:23 -0400, Bob Copeland wrote:
> On Fri, Mar 13, 2009 at 6:38 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> >
> > Just compiled and installed latest wireless-testing with Nick's patches,
> > and your patch.
> >
> > System is rock solid, module reload/s2disk/s2ram/long transfers work
> > just fine.
> 
> Great, thanks for the test!
> 

Just few random notes:



I noticed that sometimes NM couldn't scan after  s2ram on aspire one.

On the other hand doing iwlist scan, doesn't say device is busy, but
also hangs. Nothing interesting in the logs.
Module reload helps.


The above with updated wpa_supplicant there (latest -git) NM is from
ubuntu PPA archive yet, not sure if happens with stable one.

I also applied two patches from Helmut Schaa, maybe it was the cause.



I also noticed on both my notebooks, that wpa supplicant (stable too)
fails to do first scan, and retries after 10 seconds.
I changed this to 1 sec on my main notebook, and 2 seconds on ath5k.




I also happy to say that I don't see anymore reset hangs. Maybe tx power
patches fixed that?



Also it seems that scan results show correct power levels for APs near
me, including mine (they usually were very different from these I got
from iwlwifi - now more or less they are the same)



My AP is -51dBm ~ -45 dBm 



>From now on, during two/three weeks I will try not to use my computers
I have very big exams very soon. So I might not read email.

But then I will be free for some long time to help with anything I can.


Best regards and thanks again,
	Maxim Levitsky

