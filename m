Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:30530 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYBAMlk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:41:40 -0500
Received: by py-out-1112.google.com with SMTP id u52so1599825pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 04:41:40 -0800 (PST)
Message-ID: <43e72e890802010441n4770fe0ag69899a537f551080@mail.gmail.com> (sfid-20080201_124144_344033_29A45FE6)
Date: Fri, 1 Feb 2008 07:41:39 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] ath5k: Cleanup after API changes patch
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, bruno@thinktube.com,
	jirislaby@gmail.com, mickflemm@gmail.com
In-Reply-To: <1201869496.4188.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080201012544.GD28995@ruslug.rutgers.edu>
	 <1201869496.4188.15.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 1, 2008 7:38 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > Finally make a note that we should eventually move cap_range stuff
> > to struct wiphy.
>
> What is cap_range and why should it be in struct wiphy?

Its the device's frequency capability range on the bands.

  Luis
