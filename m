Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab3CDUH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 15:07:56 -0500
Message-ID: <1362427664.21028.40.camel@jlt4.sipsolutions.net> (sfid-20130304_210759_696647_A09EED87)
Subject: Re: [PATCH 4/6] nl80211: user_mpm overrides auto_open_plinks
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Mon, 04 Mar 2013 21:07:44 +0100
In-Reply-To: <CAG6hwVPGJk4CGcibimaSB5ADjcUmyhzNkF4JW4eveBDZma+SnA@mail.gmail.com> (sfid-20130304_210430_527087_7D3FAF89)
References: <1362204172-28307-1-git-send-email-thomas@cozybit.com>
	 <1362204172-28307-4-git-send-email-thomas@cozybit.com>
	 <1362409848.21028.16.camel@jlt4.sipsolutions.net>
	 <CAG6hwVPGJk4CGcibimaSB5ADjcUmyhzNkF4JW4eveBDZma+SnA@mail.gmail.com>
	 (sfid-20130304_210430_527087_7D3FAF89)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-04 at 12:04 -0800, Thomas Pedersen wrote:

> >> +     if (setup.user_mpm)
> >> +             cfg.auto_open_plinks = false;
> >
> > Maybe you should reject the invalid configuration instead?
> 
> But then if the user wants "userspace MPM" they have to select that
> and disable auto_open_plinks as well. I think if the user wants his
> own MPM, the kernel should be smart enough to completely disable its
> own.

Ok, fair enough.

johannes

