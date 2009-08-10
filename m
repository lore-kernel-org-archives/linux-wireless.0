Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45305 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZHJSBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 14:01:08 -0400
Date: Mon, 10 Aug 2009 13:52:25 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Javier Cardona <javier@cozybit.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, andrey@cozybit.com,
	devel@lists.open80211s.org
Subject: Re: Mesh fixes and improvements
Message-ID: <20090810175225.GF2733@tuxdriver.com>
References: <1249702711-32737-1-git-send-email-javier@cozybit.com> <1249722543.31670.19.camel@johannes.local> <445f43ac0908082155n7cdde6e2p7656177fc2952be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <445f43ac0908082155n7cdde6e2p7656177fc2952be@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 08, 2009 at 09:55:56PM -0700, Javier Cardona wrote:
> On Sat, Aug 8, 2009 at 2:09 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> >> Also, I'm not sure if "Simulate-transmission-losses-on-plinks-to-..." should be
> >> merged upstream, but we find it really useful to test mesh configurations.
> >> Please comment if you have different opinions on its adequacy or
> >> implementation.
> >
> > As I said elsewhere in this thread I don't think that should be in,
> > especially not, as Kalle points out, using nl80211.
> 
> Understood.  I'll withdraw that patch and regenerate the series...

Dropping the series based on the above comment...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
