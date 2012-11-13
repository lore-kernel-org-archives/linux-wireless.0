Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42340 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab2KMU4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 15:56:11 -0500
Message-ID: <1352840204.9466.34.camel@jlt4.sipsolutions.net> (sfid-20121113_215614_262498_94FC9E11)
Subject: Re: [PATCH v2] mac80211: support RX_FLAG_MACTIME_END
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Nov 2012 21:56:44 +0100
In-Reply-To: <CAG6hwVPhzSyFPHj8p37Si8dHpFBH6Q98RNhuWnRKY7kmk24crA@mail.gmail.com> (sfid-20121113_215347_094983_CB05C52C)
References: <1352832387-21162-1-git-send-email-thomas@cozybit.com>
	 <1352839474.9466.33.camel@jlt4.sipsolutions.net>
	 <CAG6hwVPhzSyFPHj8p37Si8dHpFBH6Q98RNhuWnRKY7kmk24crA@mail.gmail.com>
	 (sfid-20121113_215347_094983_CB05C52C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-13 at 12:53 -0800, Thomas Pedersen wrote:
> On Tue, Nov 13, 2012 at 12:44 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Tue, 2012-11-13 at 10:46 -0800, Thomas Pedersen wrote:
> >> Allow drivers to indicate their mactime is at RX completion and adjust
> >> for this in mac80211. Also rename the existing RX_FLAG_MACTIME_MPDU to
> >> RX_FLAG_MACTIME_START to clarify its intent. Based on similar code by
> >> Johannes Berg.
> >
> > Applied, but I had to fix up the patch to apply on mac80211-next, and
> > even had to make it compile by adjusting the Atheros drivers ...
> 
> Rats. It applied on wireless-testing. In the future, submitted
> mac80211 patches should be rebased onto mac80211-next?

Honestly, wireless-testing usually works, it's just that John hasn't
pulled for a while and there's a whole bunch of stuff in mac80211-next
right now. No biggie to fix up really, though I think you should've
fixed up the Atheros drivers :)

johannes

