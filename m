Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:55677 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755982Ab3GVREm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 13:04:42 -0400
Message-ID: <1374512681.2061.53.camel@joe-AO722> (sfid-20130722_190445_187527_8E07E61E)
Subject: Re: [PATCH 1/2] MAINTAINERS: add ath10k
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Mon, 22 Jul 2013 10:04:41 -0700
In-Reply-To: <87zjtewmzg.fsf@kamboji.qca.qualcomm.com>
References: <20130722093113.26562.11543.stgit@localhost6.localdomain6>
	 <20130722093220.26562.14270.stgit@localhost6.localdomain6>
	 <1374504278.2061.35.camel@joe-AO722>
	 <87zjtewmzg.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-07-22 at 19:58 +0300, Kalle Valo wrote:
> Joe Perches <joe@perches.com> writes:
> 
> > On Mon, 2013-07-22 at 12:32 +0300, Kalle Valo wrote:
> >> I forgot to add an entry to MAINTAINERS when submitting the driver.
> > []
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> > []
> >> +QUALCOMM ATHEROS ATH10K WIRELESS DRIVER
> >
> > It's odd to not find ATH6KL next to ATH10K.
> 
> I was wondering the same, but decided to put the entries in alphabetical
> order still.
> 
> > Maybe it's time to rename all the ATH sections
> > to make them QUALCOMM?
> 
> Maybe, but does it really matter?

Only to those that actually read the MAINTAINERS
file instead of using tools to search it.

> Changing the MAINTAINERS file just
> creates unnecessary conficts for git merges.

Those are always trivially resolved if they
ever really occur.

It's not a big deal, just wanted to note it.


