Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaLRPbO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 10:31:14 -0500
Message-ID: <1418916658.2086.3.camel@dcbw.local> (sfid-20141218_163132_779939_59EDB4D8)
Subject: Re: changes to Linux wireless maintenance
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-nfc@ml01.01.org, "David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>, lwn@lwn.net
Date: Thu, 18 Dec 2014 09:30:58 -0600
In-Reply-To: <20141217155951.GA3144@tuxdriver.com>
References: <20141217155951.GA3144@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-17 at 10:59 -0500, John W. Linville wrote:
> Greetings,
> 
> Almost 9 years ago, Jeff Garzik wrote a message on LKML detailing
> the sad state of wireless LANs in the Linux world.  The point of his
> message was "So... there it is.  We suck.  There's hope.  No Luke
> Skywalker in sight.":
> 
> 	https://lkml.org/lkml/2006/1/5/671
> 
> Shortly thereafter, I became the maintainer for wireless LANs in the
> Linux kernel:
> 
> 	https://lkml.org/lkml/2006/1/18/377
> 
> Since then, we have had a number of wireless summit meetings all around
> the world.  Items were discussed, patches were merged, and friendships
> were made.  Over time, we garnered support from a large range of
> wireless networking vendors.  Eventually even other technologies
> were sending their patches through my trees, and I was consistently
> ranked amongst the top 10 "gate keepers" for getting changes into the
> Linux kernel.  In fact, a couple of years ago I even gave a talk on
> how Linux wireless got better.	It has been quite a ride!
> 
> 	https://events.linuxfoundation.org/images/stories/pdf/lfcs2012_linville.pdf
> 
> Nevertheless, I think it is time for some changes.  I have been
> the wireless maintainer for a long time, and I personally would
> like to develop in a different direction.  Plus, I think that Linux
> will benefit from having some fresh blood involved in more of the
> maintenance duties.  I will be stepping aside to let that happen.

Thanks John!  It's been a great ride and you're a huge part of the
reason wireless happened.  Nobody can thank you enough!

Dan

> The mac80211, bluetooth, and nfc trees have fed through me for some
> time.  I am now asking these trees to send pull request directly to
> David Miller.  Since these trees are managed through git, my hope is
> that they will not place any significant burden on Dave.
> 
> As for the wireless driver patches, I have asked Kalle Valo
> to handle patch review and merge duties for everything under the
> drivers/net/wireless directory.  This will now include not only the ath
> patches he already manages, but other drivers that don't have trees
> such as mwifiex, rt2x00, rtlwifi, and others.  For consistency, the
> iwlwifi tree will also be merged through Kalle's new tree.  I expect
> that Kalle will announce any relevant details in a follow-up message.
> 
> The wireless-testing tree is a resource that some people value.
> I will continue to provide a wireless-testing tree.  Now that tree
> will feed from the various wireless trees managed by others, probably
> with some sort of regularly scheduled pulls.  Details are still to be
> determined, but the tree will still exist and will be substantially
> similar to how it has been so far.
> 
> I also receive notices of new bug reports for wireless LANs on
> bugzilla.kernel.org.  For now I will continue to triage those reports,
> so don't ignore me!! :-)
> 
> Some may ask what I will do now -- I wish I had a specific answer.
> Immediate plans are to enjoy the coming holidays and my traditional
> year-end time away from work.  After that...well, I'm sure I will
> find something to do.  If you have any suggestions for good uses of
> my talents, feel free to contact me -- I'm not hard to find!
> 
> In closing, I hope everyone will support Kalle and the other wireless
> maintainers at least as much as you have supported me for the past
> several years.	These are good, hard working folks.  You are in
> good hands!
> 
> Regards,
> 
> John
> 
> P.S.  Bonus points for anyone that finds a way for me to become a
> professional retro-computing hobbyist... :-)


