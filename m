Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:62101 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761642AbXG0TQf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 15:16:35 -0400
Date: Fri, 27 Jul 2007 21:16:34 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Jiri Benc <jbenc@suse.cz>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: mac80211 git tree reworked
Message-ID: <20070727191634.GA16949@deine-taler.de>
References: <20070727175716.32242e3f@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070727175716.32242e3f@griffin.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:

> What I'm proposing to do now?
> - Throw away current wireless-dev and start it from scratch from the
>   current vanilla.
> - Apply patches from up-dev branch of mac80211 tree.
> - Apply all drivers. That's a bit tricky and I'm aware that some people
>   won't agree but I think it's easiest to apply them as one big patch
>   for each (that's the form in which they will be submitted to vanilla
>   anyway). They have been moved out of mac80211 directory recently so
>   perhaps it's a good time to do that. I can help with creating such
>   patches.

Do we really need two git trees in the future? And do we need all
those different branches in a public tree?

I suggest that we go back now to a single wireless tree, that
should have only those three branches:

master     - latest tree put together by John
up         - tree with patches going into mainline
up-2.6.x.y - bug fixes against last released mainline

Will John have more branches in its private tree? Sure! Will the
wireless developers have their own public trees? Certainly! But I
really question the value of two wireless trees with a larger
number of branches.

-- 
Uli Kunitz
