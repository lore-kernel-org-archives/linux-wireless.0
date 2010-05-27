Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49349 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab0E0SpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 14:45:13 -0400
Date: Thu, 27 May 2010 14:41:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Weedy <weedy2887@gmail.com>, Richard Farina <sidhayn@gmail.com>,
	=?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: ath5k past 2.6.30 breaks monitor mode (and thus the aircrack
 suite)
Message-ID: <20100527184110.GB3728@tuxdriver.com>
References: <AANLkTimYeL4KQozuTl4le9WUpObsjwp0YAx7eAYq6MBr@mail.gmail.com>
 <AANLkTikOgv6d0FlXu2-smnYPApeehjRq_j8UxEealqFC@mail.gmail.com>
 <AANLkTinynNqs6_zyTJcpi7yKiSvC5fBhbM2tVZcnoNUq@mail.gmail.com>
 <AANLkTinyGlwqq4xshLU5Ol74p0VfcUXBjBGKXlsB2pMy@mail.gmail.com>
 <AANLkTimIeTadyAhUuri2P630mpDwmBk4B90RpERLbaFE@mail.gmail.com>
 <AANLkTilXJHs8emXX4YNHbPq0SkuC4Z22NEh-T6mwUSHS@mail.gmail.com>
 <4BFDEBDC.4070304@gmail.com>
 <AANLkTin3VSp_FcSiadD4efE1Yo1vKiDXmOngsHEKiQmF@mail.gmail.com>
 <AANLkTilPvGLRhwZBY3q9UXLaq-zbI9U-VhFNx1dfq1mH@mail.gmail.com>
 <AANLkTil5yP2xZ5sBXmDEVCHvD2oim92R-dfHx6f-pLOS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTil5yP2xZ5sBXmDEVCHvD2oim92R-dfHx6f-pLOS@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 27, 2010 at 02:31:12PM -0400, Bob Copeland wrote:
> On Thu, May 27, 2010 at 1:40 PM, Weedy <weedy2887@gmail.com> wrote:
> 
> >> Weedy, if you want reported-by credit can you give your full name and
> >> preferred email address?
> > Do I have to? I don't really want to tie my name to this email :/
> 
> Honestly I don't know what reported-by policy is (other than I should
> get your consent first).  I guess John can weigh in whether:
> 
>    Reported-by: weedy2887@gmail.com
> 
> is acceptable.  For S-o-b, the rule is no anonymous or pseudonymous
> contributions.  Of course, you don't have to be credited, but your
> bisection was a huge help in pinning it down :)

It isn't necessary, and I suspect that someone that doesn't want his
name attached doesn't wanted the addition of any further unnecessary
evidence in the git changelogs either. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
