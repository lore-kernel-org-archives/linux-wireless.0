Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58406 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbaEZJyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 05:54:38 -0400
Message-ID: <1401098065.30496.0.camel@jlt4.sipsolutions.net> (sfid-20140526_115441_412472_72FB649F)
Subject: Re: [regdb] Add support to parse 2000mW tx power
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Luis Rodriguez <mcgrof@gmail.com>,
	wireless-regdb@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 26 May 2014 11:54:25 +0200
In-Reply-To: <CABPxzYKe5Cy36uc=C5wVEVZV0qiR=55yBw0LtzuRv412p58c9g@mail.gmail.com> (sfid-20140526_114652_916732_D4E99F80)
References: <1401089962-10720-1-git-send-email-chaitanya.mgit@gmail.com>
	 <1401097086.29704.0.camel@jlt4.sipsolutions.net>
	 <CABPxzYKe5Cy36uc=C5wVEVZV0qiR=55yBw0LtzuRv412p58c9g@mail.gmail.com>
	 (sfid-20140526_114652_916732_D4E99F80)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-05-26 at 15:16 +0530, Krishna Chaitanya wrote:
> On Mon, May 26, 2014 at 3:08 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2014-05-26 at 13:09 +0530, chaitanya.mgit@gmail.com wrote:
> >
> >> @@ -74,7 +74,7 @@ function parse_reg_rule()
> >>                       power = 23
> >>               } else if (power == 500) {
> >>                       power = 27
> >> -             } else if (power == 1000) {
> >> +             } else if ((power == 1000) || (power == 2000)) {
> >>                       power = 30
> >
> > This seems like a pretty sick thing to do to start with, and certainly
> 
> Agree.
> 
> > power=30 isn't right for 2000mW...
> 
> Sorry, typo. Its supposed to be 33.
> 
> > Can't awk calculate the logarithm?
> Does kernel support log arithmetic/Float operations.?

This script runs at build time.

johannes


