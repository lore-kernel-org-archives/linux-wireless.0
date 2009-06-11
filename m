Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:35158 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbZFKN6k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 09:58:40 -0400
Date: Thu, 11 Jun 2009 21:29:54 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: VT6656 driver source now GPL
Message-ID: <20090611132954.GA20845@prithivi.gnumonks.org>
References: <20090319164256.GA25237@storm.local.network> <43e72e890903190945m4d8920f5y69f5847b688b0aa1@mail.gmail.com> <20090320131014.GG25237@storm.local.network> <20090414000835.GA31504@storm.local.network>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090414000835.GA31504@storm.local.network>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

On Mon, Apr 13, 2009 at 08:08:35PM -0400, Forest Bond wrote:

> > > > VIA has released a new version of the VT6656 driver source, and it now has a
> > > > proper license!

Which is what VIA always had intended, but by accident it seemed to go wrong.
What would be the point of having an open-source driver and then not licensing
it under the GPL.

In any case, sorry that it too VIA so long to get to that point.

I was also pushing internally for a new mainline driver that would not come with
its own wifi stack.  Unfortunately there are no resources for that, and that
department even lost some of their developers, so I doubt there is change any
time soon.

However, for future VIA wifi products I have a committment that their drivers
will be developed more 'mainline style'.

As for the VT6656: I have recently also received some hardware for testing +
development.  I am free to work on a new driver for mainline (I doubt any
cleaning up would help) as I please - but then my time is severely limited,
I'm also trying to improve the situation with regard to tons of other VIA
chips.

> I'm getting the sense that there is not a lot of developer interest in these
> drivers.  

I am not surprised.  I personally have not yet seen any remotely popular
product in the market that uses a VIA wifi chip.  However, this might change
significantly in Q3/Q4 this year.

If anyone wants to work on a new driver for the vt6656: I am happy to help with
interfacing VIA's R&D in case there are some specific questions.  I
unfortunately cannot help with releasing documentation, as there is almost zero
documentation on that part. (not a big surprise, even Intel has no programming
manuals for their wifi chips...)

Cheers,
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
