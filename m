Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3355 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124AbYBFUdX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 15:33:23 -0500
Date: Wed, 6 Feb 2008 15:10:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, bruno randolf <bruno@thinktube.com>,
	Johannes Berg <johannes@sipsolutions.net>, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Kishore Ramachandran <kishore@winlab.rutgers.edu>,
	Ivan Seskar <Seskar@winlab.rutgers.edu>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Message-ID: <20080206201035.GA3229@tuxdriver.com> (sfid-20080206_203326_360140_726DDEAC)
References: <20080118125252.6455.41047.stgit@one> <200801241226.28394.bruno@thinktube.com> <1201193704.3454.137.camel@johannes.berg> <200801251701.59629.bruno@thinktube.com> <43e72e890802021522g5bffe97cg31ba57f6f1f200b9@mail.gmail.com> <20080206043451.GT1261@jm.kir.nu> <43e72e890802061033k5ca3e83doca28ca43a5c1830b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890802061033k5ca3e83doca28ca43a5c1830b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 06, 2008 at 01:33:31PM -0500, Luis R. Rodriguez wrote:
> On Feb 5, 2008 11:34 PM, Jouni Malinen <j@w1.fi> wrote:

> > The BSSID generation as a hash from SSID does not sound like something
> > that would match the requirements of IEEE 802.11 11.1.6 ("a number
> > selected in a manner that minimizes the probability of STAs generating
> > the same number") since it is actually maximizing that probablity for
> > the case of same SSID ;-).
> 
> Heh, good catch :)

FWIW, that wouldn't be the first time we (i.e. Linux) chose to do
something that did not completely comply with a standard.  If it
interoperates with other equipment and is good for users, I don't
think picky standard compliance is worthwhile.

Please note that I am not really taking a stand in favor of this ATM,
only asserting that blind standard compliance is not a good reason
to NAK it IMHO.

John
-- 
John W. Linville
linville@tuxdriver.com
