Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40498 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbZKCTPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 14:15:04 -0500
Date: Tue, 3 Nov 2009 14:01:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: CSights <csights@fastmail.fm>, linux-wireless@vger.kernel.org
Subject: Re: ath5k and ".local" dropout
Message-ID: <20091103190149.GE4839@tuxdriver.com>
References: <200911021907.16271.csights@fastmail.fm> <20091103180055.GC4839@tuxdriver.com> <b6c5339f0911031054g13443c17ma925014fb9b16ab8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <b6c5339f0911031054g13443c17ma925014fb9b16ab8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 03, 2009 at 01:54:10PM -0500, Bob Copeland wrote:
> On Tue, Nov 3, 2009 at 1:00 PM, John W. Linville <linville@tuxdriver.com> wrote:
> >
> > The .local address relationship suggests multicast DNS, which suggests
> > that ath5k might have a problem where it stops receiving multicast
> > frames.  Does this "ring any bells" for anyone?
> 
> Yeah in fact I posted a patch to ath5k-devel but forgot to copy
> linux-wireless. :)
> 
> We zero out the mcast filter for some reason, I'm not sure why.  Maybe missing
> tildes in front of the zeroes or something.

Any feedback on that patch? :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
