Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36982 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1HVSpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 14:45:10 -0400
Date: Mon, 22 Aug 2011 14:34:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Subject: Re: [PATCH v2 1/8] mac80211: improve mpath debugging
Message-ID: <20110822183432.GI2534@tuxdriver.com> (sfid-20110822_204514_620211_EFBF102F)
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
 <1313117641-27351-1-git-send-email-thomas@cozybit.com>
 <1313152101.4022.3.camel@jlt3.sipsolutions.net>
 <CAG6hwVN+D+XXAR9B8ZAb2hf_OFKwE875tm=OAS7iytx32uU9MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAG6hwVN+D+XXAR9B8ZAb2hf_OFKwE875tm=OAS7iytx32uU9MA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 12, 2011 at 11:12:08AM -0700, Thomas Pedersen wrote:
> On Fri, Aug 12, 2011 at 5:28 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:

> > Definitely want the format attribute, that was my whole point :)
> 
> Oh I see. Looking at it again, my function above doesn't even have any
> argument checking :P. Didn't know about that __attribute__ etiher,
> thanks!
> 
> > Bah, maybe it all doesn't matter, in which case maybe the first version
> > is better.
> 
> Sure, let's go with the first one.

OK, I'm confused -- do we want to merge the versions posted on
9 August?  Or the ones from 11 August?  Or...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
