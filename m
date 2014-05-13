Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38938 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbaEMPxw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 11:53:52 -0400
Message-ID: <1399996416.4137.27.camel@jlt4.sipsolutions.net> (sfid-20140513_175356_222497_CBA41A1A)
Subject: Re: [PATCH v5] mac80211: implement multi-vif in-place reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Date: Tue, 13 May 2014 17:53:36 +0200
In-Reply-To: <CA+BoTQmG_oFNgjJLr4DdEwnjtu0pC9HiQ8DhapVuhu1u1hXypw@mail.gmail.com> (sfid-20140513_155622_752722_FF831C3F)
References: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
	 <1398849681-3606-1-git-send-email-michal.kazior@tieto.com>
	 <1399372915.4218.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk1upg7yGK-QWoz8QhMeRzLBY60Lk=eUN=iQLaF2pUhQQ@mail.gmail.com>
	 <1399385141.4218.37.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnGRtdOGfJ78EG43cmND2bD9m3WyvmSKx92uBFnKenPkw@mail.gmail.com>
	 <1399450061.5038.10.camel@jlt4.sipsolutions.net>
	 <1399455657.6800.4.camel@dubbel>
	 <CA+BoTQmXb=_jjE4-dL8U_-8=CxRMgo4qckUKF9LizfV2W0iC7A@mail.gmail.com>
	 <1399457760.6800.7.camel@dubbel>
	 <CA+BoTQnF3pVmGumqqHbfuphXbYhAybHUMosX4kJazfHWJDE+Fw@mail.gmail.com>
	 <1399460964.10517.12.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnSJgaN=incAtW08tSqDgW2jRm1cdarMhupArGBAw7FRQ@mail.gmail.com>
	 <1399463646.10517.28.camel@jlt4.sipsolutions.net>
	 <1399464536.6800.11.camel@dubbel>
	 <1399464789.10517.29.camel@jlt4.sipsolutions.net>
	 <1399465244.6800.13.camel@dubbel>
	 <1399466312.10517.34.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmDF2NiWK_PbTYKxFecajiaH6nEPej0ENP7HBZ1ym83sw@mail.gmail.com>
	 <1399467225.10517.35.camel@jlt4.sipsolutions.net>
	 <CA+BoTQn0LR9SMzY3zQQXwuPOdkBUgMpADOrHucMKxjouRcap8Q@mail.gmail.com>
	 <1399543568.9163.5.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk_hm-dgNftTK_WdPQFNgD9WyRG01sPQ0vcO=cw7+BNrg@mail.gmail.com>
	 <1399988536.4137.23.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmG_oFNgjJLr4DdEwnjtu0pC9HiQ8DhapVuhu1u1hXypw@mail.gmail.com>
	 (sfid-20140513_155622_752722_FF831C3F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-13 at 15:56 +0200, Michal Kazior wrote:

> > That's pretty much what I'd considered, except that now as far as I read
> > the thread this wasn't sufficient for multi-context, so we'd need lists
> > of old/new contexts?
> 
> Hmm.. In what cases do you need a list of old/new contexts?

That was Luca's scenario, no?

johannes

