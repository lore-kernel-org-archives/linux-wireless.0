Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:48472 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840AbYBAMwa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:52:30 -0500
Received: by py-out-1112.google.com with SMTP id u52so1605484pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 04:52:29 -0800 (PST)
Message-ID: <43e72e890802010452s510628ear49136748e06fc670@mail.gmail.com> (sfid-20080201_125236_469192_C9F6CD72)
Date: Fri, 1 Feb 2008 07:52:28 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: Cleanup after API changes patch
Cc: jirislaby@gmail.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	bruno@thinktube.com
In-Reply-To: <1201869970.4188.24.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080201012544.GD28995@ruslug.rutgers.edu>
	 <1201869496.4188.15.camel@johannes.berg>
	 <43e72e890802010441n4770fe0ag69899a537f551080@mail.gmail.com>
	 <1201869970.4188.24.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/2/1 Johannes Berg <johannes@sipsolutions.net>:
>
> > > What is cap_range and why should it be in struct wiphy?
> >
> > Its the device's frequency capability range on the bands.
>
> Well since we always need channels I decided to not have such a thing
> but rather require registering a channels array that is also used for
> bookkeeping about enabled/disabled channels etc.
>
> I guess you could add a helper function that allocates a channels array
> based on a frequency range.

This is true but also it would be nice as it is the end points which
drivers may want
to access every now and then. I think its worth the few bytes.

  Luis
