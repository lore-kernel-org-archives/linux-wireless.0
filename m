Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab2LMWde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:33:34 -0500
Message-ID: <1355438035.9463.31.camel@jlt4.sipsolutions.net> (sfid-20121213_233336_388236_45600A74)
Subject: Re: [RFC 1/2] regulatory: allow arbitrary channel widths
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Michael Green <green@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 13 Dec 2012 23:33:55 +0100
In-Reply-To: <1355437992.9463.30.camel@jlt4.sipsolutions.net> (sfid-20121213_233255_186959_87A0FE01)
References: <1354812784-15845-1-git-send-email-johannes@sipsolutions.net>
	 <1354812784-15845-2-git-send-email-johannes@sipsolutions.net>
	 <CAB=NE6XpVxRudaZ0EXRR6KkgPOTqw4pXO+x0Pim+Bt2_HT8fnQ@mail.gmail.com>
	 <CAB=NE6XbbkoWyMyjWtV6EpbT4A7MS5fZRiXgd_Pdok8eE1-e0Q@mail.gmail.com>
	 (sfid-20121213_232850_441393_F837467A) <1355437992.9463.30.camel@jlt4.sipsolutions.net>
	 (sfid-20121213_233255_186959_87A0FE01)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 23:33 +0100, Johannes Berg wrote:
> On Thu, 2012-12-13 at 14:28 -0800, Luis R. Rodriguez wrote:
> > Oops, forgot to add Michael, adding him now.
> > 
> > Michael, just a sanity check for you. What Johannes is saying is that
> > regulatory wise for the 2.4 GHz band on channels 1-11 and on 5 GHz on
> > non DFS channels where we never initiate radiation we don't have a
> > specific bandwidth restriction. Are you aware of any country
> > restricting any 5 GHz world roaming frequency (non DFS) or channel
> > 1-11 on 2.4 GHz in terms of bandwidth used?
> 
> This is world roaming, so we never use any of the 5 GHz channels unless
> we've heard a beacon. If we hear beacons on consecutive (non-DFS)
> channels (say 36,40,44,48) we would even enable them and then allow
> using 80 MHz there. We could try to prevent this in some way I guess,
> but it'd be more complex, and I'm not sure it's needed. However, I think
> we need to be able to use 80 MHz in world roaming situations, which the
> bandwidth setting currently prevents.

Btw, soon enough I'll need to update the regdb for VHT, so if anyone has
any worldwide data on 80/160 MHz restrictions I'd love to know about it.

johannes

